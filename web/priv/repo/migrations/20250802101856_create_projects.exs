defmodule Ignite.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :path, :string, null: false
      add :name, :string, null: false
      
      timestamps()
    end

    create unique_index(:projects, [:path])
  end
end