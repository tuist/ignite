defmodule IgniteWeb.GraphQL.Schema do
  use Absinthe.Schema
  
  import_types IgniteWeb.GraphQL.Types
  
  alias IgniteWeb.GraphQL.Resolvers
  
  query do
    @desc "Get all projects"
    field :projects, list_of(:project) do
      resolve &Resolvers.Project.list_projects/3
    end
    
    @desc "Get a specific project"
    field :project, :project do
      arg :id, non_null(:id)
      resolve &Resolvers.Project.get_project/3
    end
    
    @desc "Get all simulators"
    field :simulators, list_of(:simulator) do
      resolve &Resolvers.Simulator.list_simulators/3
    end
    
    @desc "Get all devices"
    field :devices, list_of(:device) do
      resolve &Resolvers.Simulator.list_devices/3
    end
  end
  
  mutation do
    @desc "Create a new project"
    field :create_project, :project do
      arg :name, non_null(:string)
      arg :path, non_null(:string)
      resolve &Resolvers.Project.create_project/3
    end
    
    @desc "Update a project"
    field :update_project, :project do
      arg :id, non_null(:id)
      arg :name, :string
      arg :path, :string
      resolve &Resolvers.Project.update_project/3
    end
    
    @desc "Delete a project"
    field :delete_project, :project do
      arg :id, non_null(:id)
      resolve &Resolvers.Project.delete_project/3
    end
  end
  
  subscription do
    @desc "Subscribe to project updates"
    field :project_updated, :project do
      config fn _args, _context ->
        {:ok, topic: "projects:*"}
      end
      
      trigger [:create_project, :update_project, :delete_project], 
        topic: fn 
          %{id: id} -> ["projects:*", "projects:#{id}"]
          _ -> ["projects:*"]
        end
    end
    
    @desc "Subscribe to build output"
    field :build_output, :build_output do
      arg :build_id, non_null(:id)
      
      config fn args, _context ->
        {:ok, topic: "build:#{args.build_id}"}
      end
    end
  end
end