defmodule Ignite.BrowserLauncher do
  @moduledoc """
  Launches the system browser and binds its lifecycle to the Elixir process.
  When the Elixir process exits, it will terminate the browser process.
  """

  use GenServer
  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :temporary
    }
  end

  @impl true
  def init(opts) do
    # Don't launch in test environment
    if Mix.env() == :test do
      :ignore
    else
      # Wait a bit for the server to be ready
      Process.send_after(self(), :launch_browser, 1000)
      {:ok, %{opts: opts, browser_pid: nil}}
    end
  end

  @impl true
  def handle_info(:launch_browser, state) do
    url = build_url()
    Logger.info("Opening browser at #{url}")
    
    # Use MuonTrap to launch the browser process
    # The browser process will be terminated when this GenServer stops
    case launch_browser(url) do
      {:ok, os_pid} ->
        Logger.info("Browser launched with OS PID: #{os_pid}")
        {:noreply, %{state | browser_pid: os_pid}}
        
      {:error, reason} ->
        Logger.error("Failed to launch browser: #{inspect(reason)}")
        {:noreply, state}
    end
  end

  @impl true
  def terminate(_reason, %{browser_pid: pid}) when not is_nil(pid) do
    Logger.info("Terminating browser process #{pid}")
    # MuonTrap should handle cleanup, but we can be explicit
    :ok
  end

  def terminate(_reason, _state), do: :ok

  defp build_url do
    config = Application.get_env(:ignite, IgniteWeb.Endpoint, [])
    
    # Get URL configuration
    url_config = config[:url] || []
    host = url_config[:host] || "localhost"
    
    # Get port configuration
    http_config = config[:http] || []
    https_config = config[:https] || []
    
    port = case {http_config[:port], https_config[:port]} do
      {nil, nil} -> 4000
      {http_port, nil} -> normalize_port(http_port)
      {nil, https_port} -> normalize_port(https_port)
      {http_port, _} -> normalize_port(http_port)
    end
    
    scheme = if https_config[:port], do: "https", else: "http"
    
    "#{scheme}://#{host}:#{port}"
  end

  defp normalize_port(port) when is_binary(port) do
    System.get_env("PORT", port)
  end
  
  defp normalize_port(port), do: port

  defp launch_browser(url) do
    case :os.type() do
      {:unix, :darwin} ->
        # On macOS, we'll use a different approach
        # Create a small script that launches the browser and waits
        launch_macos_browser(url)
        
      {:unix, _} ->
        # On Linux, xdg-open usually returns immediately
        launch_linux_browser(url)
        
      {:win32, _} ->
        # On Windows
        launch_windows_browser(url)
    end
  end

  defp launch_macos_browser(url) do
    # Use the -W flag to wait until the browser is closed
    # This will block until the browser tab/window with our URL is closed
    Logger.info("Launching browser with wait mode...")
    
    # MuonTrap will handle the process lifecycle
    # When the Elixir process exits, MuonTrap will kill the open command
    # which in turn will close the browser
    case MuonTrap.cmd("open", ["-W", url], []) do
      {_, 0} -> 
        Logger.info("Browser closed normally")
        {:ok, nil}
      {output, code} -> 
        {:error, "Failed to launch browser: #{output} (exit: #{code})"}
    end
  end

  defp launch_linux_browser(url) do
    # Similar approach for Linux
    case MuonTrap.cmd("xdg-open", [url], []) do
      {_, 0} -> {:ok, nil}
      {output, code} -> {:error, "Failed to launch browser: #{output} (exit: #{code})"}
    end
  end

  defp launch_windows_browser(url) do
    case MuonTrap.cmd("cmd", ["/c", "start", url], []) do
      {_, 0} -> {:ok, nil}
      {output, code} -> {:error, "Failed to launch browser: #{output} (exit: #{code})"}
    end
  end

end