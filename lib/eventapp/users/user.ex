defmodule Eventapp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :picture_hash, :string

    #indicates a one-to-many relationship of user to posts
    has_many :posts, Eventapp.Posts.Post


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :picture_hash])
    |> validate_required([:username, :email, :picture_hash])
  end
end
