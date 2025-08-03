defmodule Ignite.Project do
  use Ignite.Schema

  schema "projects" do
    field :path, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:path, :name])
    |> validate_required([:path, :name])
    |> unique_constraint(:path)
  end

  @doc """
  Creates or updates a project from a path.
  The name is derived from the basename of the path.
  """
  def from_path(path) do
    name = Path.basename(path)
    
    %__MODULE__{}
    |> changeset(%{path: path, name: name})
  end
end