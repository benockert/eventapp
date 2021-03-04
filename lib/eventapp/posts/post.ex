defmodule Eventapp.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  #defines the event data and their types
  schema "posts" do
    field :date, :string
    field :description, :string
    field :invitees, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:name, :date, :description, :invitees])
    |> validate_required([:name, :date, :description, :invitees])
  end
end
