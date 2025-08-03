defmodule IgniteWeb.GraphQL.Resolvers.Project do
  alias Ignite.Projects
  
  def list_projects(_parent, _args, _resolution) do
    {:ok, Projects.list_projects()}
  end
  
  def get_project(_parent, %{id: id}, _resolution) do
    case Projects.get_project!(id) do
      nil -> {:error, "Project not found"}
      project -> {:ok, project}
    end
  rescue
    Ecto.NoResultsError -> {:error, "Project not found"}
  end
  
  def create_project(_parent, args, _resolution) do
    case Projects.create_or_update_project(args) do
      {:ok, project} ->
        # Publish to subscriptions
        Absinthe.Subscription.publish(
          IgniteWeb.Endpoint,
          project,
          project_updated: ["projects:*", "projects:#{project.id}"]
        )
        {:ok, project}
        
      {:error, changeset} ->
        {:error, format_changeset_errors(changeset)}
    end
  end
  
  def update_project(_parent, %{id: id} = args, _resolution) do
    try do
      project = Projects.get_project!(id)
      case Projects.create_or_update_project(Map.put(args, :id, id)) do
        {:ok, updated_project} ->
          # Publish to subscriptions
          Absinthe.Subscription.publish(
            IgniteWeb.Endpoint,
            updated_project,
            project_updated: ["projects:*", "projects:#{updated_project.id}"]
          )
          {:ok, updated_project}
        {:error, changeset} ->
          {:error, format_changeset_errors(changeset)}
      end
    rescue
      Ecto.NoResultsError -> {:error, "Project not found"}
    end
  end
  
  def delete_project(_parent, %{id: id}, _resolution) do
    try do
      project = Projects.get_project!(id)
      # For now, we'll mark it as inactive since there's no delete function
      case Projects.create_or_update_project(%{id: id, status: "inactive"}) do
        {:ok, updated_project} ->
          # Publish to subscriptions
          Absinthe.Subscription.publish(
            IgniteWeb.Endpoint,
            updated_project,
            project_updated: ["projects:*", "projects:#{updated_project.id}"]
          )
          {:ok, updated_project}
        {:error, changeset} ->
          {:error, format_changeset_errors(changeset)}
      end
    rescue
      Ecto.NoResultsError -> {:error, "Project not found"}
    end
  end
  
  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {field, errors} ->
      "#{field}: #{Enum.join(errors, ", ")}"
    end)
    |> Enum.join("; ")
  end
end