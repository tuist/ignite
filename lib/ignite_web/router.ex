defmodule IgniteWeb.Router do
  use IgniteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {IgniteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end
  
  pipeline :graphql do
    plug :accepts, ["json"]
  end
  
  pipeline :app do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", IgniteWeb do
    pipe_through :app
    get "/", AppController, :index
  end
  

  # GraphQL endpoints
  scope "/api" do
    pipe_through :graphql
    
    forward "/graphql", Absinthe.Plug,
      schema: IgniteWeb.GraphQL.Schema,
      context: %{pubsub: IgniteWeb.Endpoint}
      
    if Application.compile_env(:ignite, :dev_routes) do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: IgniteWeb.GraphQL.Schema,
        socket: IgniteWeb.AbsintheSocket
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ignite, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: IgniteWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
