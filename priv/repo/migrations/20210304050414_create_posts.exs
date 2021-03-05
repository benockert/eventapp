defmodule Eventapp.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :user_id, references(:users), null: false
      add :name, :string, null: false
      add :date, :string, null: false
      add :description, :string, null: false
      add :invitees, :string, null: false

      timestamps()
    end

  end
end
