defmodule Eventapp.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  #defines the event data and their types
  schema "posts" do
    field :date, :string
    field :description, :string
    field :invitees, :string
    field :name, :string

    #assign each post to the id of the user who created it
    belongs_to :user, Eventapp.Users.User

    #establishes a one-to-many relationship for post to comments
    has_many :comments, Eventapp.Comments.Comment

    #establishes a one-to-many relationship of post to responses
    has_many :responses, Eventapp.Responses.Response

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:name, :date, :description, :invitees, :user_id])
    |> validate_required([:name, :date, :description, :invitees, :user_id])
  end
end
