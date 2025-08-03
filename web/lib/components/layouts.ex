defmodule IgniteWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.
  
  Only used for the LiveDashboard now as the main app uses Vue.js.
  """
  use IgniteWeb, :html

  embed_templates "layouts/*"
end
