defmodule IgniteWeb.GraphQL.Types do
  use Absinthe.Schema.Notation
  
  object :project do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :path, non_null(:string)
    field :status, non_null(:string)
    field :last_activity, :datetime
    field :inserted_at, non_null(:datetime)
    field :updated_at, non_null(:datetime)
  end
  
  object :build_output do
    field :build_id, non_null(:id)
    field :line, non_null(:string)
    field :timestamp, non_null(:datetime)
    field :type, :string, default_value: "stdout"
  end
  
  object :simulator do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :device_type, non_null(:string)
    field :runtime, non_null(:string)
    field :state, non_null(:string)
    field :is_available, non_null(:boolean)
  end
  
  object :device do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :device_type, non_null(:string)
    field :state, non_null(:string)
  end
  
  object :build_environment_info do
    field :local_ip, non_null(:string)
    field :tailscale_url, :string
  end
  
  scalar :datetime do
    parse fn input ->
      case DateTime.from_iso8601(input.value) do
        {:ok, datetime, _} -> {:ok, datetime}
        _ -> :error
      end
    end
    
    serialize fn datetime ->
      DateTime.to_iso8601(datetime)
    end
  end
end