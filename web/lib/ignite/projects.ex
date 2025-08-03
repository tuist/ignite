defmodule Ignite.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query
  alias Ignite.Repo
  alias Ignite.Project

  @doc """
  Returns the list of projects.
  """
  def list_projects do
    Project
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single project by ID.
  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Gets a project by path.
  """
  def get_project_by_path(path) do
    Repo.get_by(Project, path: path)
  end

  @doc """
  Creates or updates a project.
  """
  def create_or_update_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert(
      on_conflict: :replace_all,
      conflict_target: :path
    )
  end

  @doc """
  Deletes a project.
  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end
end