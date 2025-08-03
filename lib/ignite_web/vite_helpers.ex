defmodule IgniteWeb.ViteHelpers do
  @moduledoc """
  Helper functions for integrating Vite with Phoenix.
  """

  @vite_manifest "priv/static/.vite/manifest.json"
  @cache_manifest "priv/static/cache_manifest.json"
  
  def vite_assets(asset_type, asset_name) do
    if Application.get_env(:ignite, :env) == :dev do
      # In development, assets are served by Vite dev server
      vite_port = "5173"
      case asset_type do
        "js" -> 
          # Add retry logic and error handling for Vite connection
          [
            """
            <script type="module">
              // Retry logic for Vite client
              let retries = 0;
              const maxRetries = 10;
              const retryDelay = 1000;
              
              function loadViteClient() {
                const script = document.createElement('script');
                script.type = 'module';
                script.src = 'http://localhost:#{vite_port}/@vite/client';
                script.onerror = function() {
                  if (retries < maxRetries) {
                    retries++;
                    console.log('Retrying Vite connection (' + retries + '/' + maxRetries + ')...');
                    setTimeout(loadViteClient, retryDelay);
                  } else {
                    console.error('Failed to connect to Vite dev server');
                  }
                };
                document.head.appendChild(script);
              }
              
              loadViteClient();
            </script>
            """,
            ~s(<script type="module" src="http://localhost:#{vite_port}/assets/js/#{asset_name}.js" defer></script>)
          ]
          |> Enum.join("\n")
          |> Phoenix.HTML.raw()
          
        "css" ->
          # CSS is handled by Vite in development
          Phoenix.HTML.raw("")
      end
    else
      # In production, read from manifest
      manifest = read_manifest()
      
      case asset_type do
        "js" ->
          entry = manifest["assets/js/#{asset_name}.js"]
          if entry do
            file = entry["file"]
            imports = Map.get(entry, "imports", [])
            css = Map.get(entry, "css", [])
            
            scripts = Enum.map(imports, fn import_key ->
              import_file = manifest[import_key]["file"]
              ~s(<link rel="modulepreload" href="/#{import_file}">)
            end)
            
            styles = Enum.map(css, fn css_file ->
              ~s(<link rel="stylesheet" href="/#{css_file}">)
            end)
            
            main_script = ~s(<script type="module" src="/#{file}"></script>)
            
            (styles ++ scripts ++ [main_script])
            |> Enum.join("\n")
            |> Phoenix.HTML.raw()
          else
            Phoenix.HTML.raw("")
          end
          
        "css" ->
          # CSS is included with JS in production
          Phoenix.HTML.raw("")
      end
    end
  end

  defp read_manifest do
    case File.read(@vite_manifest) do
      {:ok, content} ->
        Jason.decode!(content)
      {:error, _} ->
        %{}
    end
  end
  
  def cache_static_manifest do
    if Application.get_env(:ignite, :env) == :prod do
      @cache_manifest
    else
      nil
    end
  end
  
end