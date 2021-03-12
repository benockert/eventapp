defmodule Eventapp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :picture_hash, :string

    #indicates a one-to-many relationship of user to posts
    has_many :posts, Eventapp.Posts.Post

    #establishes a one-to-many relationship for user to comments
    has_many :comments, Eventapp.Comments.Comment

    #establishes a one-to-many relationship of user to responses
    has_many :responses, Eventapp.Responses.Response


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :picture_hash])
    |> validate_required([:username, :email, :picture_hash])
  end
end
