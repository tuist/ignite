defmodule IgniteWeb.AppController do
  use IgniteWeb, :controller
  
  def index(conn, _params) do
    css_tags = IgniteWeb.ViteHelpers.vite_assets("css", "app") |> Phoenix.HTML.safe_to_string()
    js_tags = IgniteWeb.ViteHelpers.vite_assets("js", "app") |> Phoenix.HTML.safe_to_string()
    
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, """
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="utf-8"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
      <meta name="csrf-token" content="#{get_csrf_token()}"/>
      <title>Ignite</title>
      #{css_tags}
      #{js_tags}
    </head>
    <body>
      <div id="app"></div>
    </body>
    </html>
    """)
  end
end