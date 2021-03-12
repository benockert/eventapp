defmodule Eventapp.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Eventapp.Repo

  alias Eventapp.Posts.Post

  alias Eventapp.Users

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
    |> Repo.preload(:user) #preloads the user for posts
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """

  # we preload the user so we can access the username of the original poster
  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload(:user)
  end

  # loads all of the comments and responses associated with the given post
  def load_resources(%Post{} = post) do
    Repo.preload(post, [comments: :user, responses: :user])
  end

  def handle_invitees(attrs) do
    # list of emails of invited users
    invitees = attrs
    |> Map.get("invitees")
    |> String.split(", ")
    |> Enum.map(fn e -> Users.check_invitee_email(e) end)
    |> Enum.join(", ")

    anyInvalid? = invitees |> String.contains?("INVALID")

    if anyInvalid? do
      {:error, "One or more invitee emails are invalid"}
    else
      {:ok, attrs}
    end

    #invitees

    # check that all are valid emails, return error with message if not

    # check if a user with that email exists

    # if they do exist, do nothing

    # if they do not exist, create a user with that email, a blank image
  end


  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    case handle_invitees(attrs) do
      {:ok, attrs} ->
        %Post{}
        |> Post.changeset(attrs)
        |> Repo.insert()
      {:error, msg} ->
        {:error, msg}
    end
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    case handle_invitees(attrs) do
      {:ok, attrs} ->
        post
        |> Post.changeset(attrs)
        |> Repo.update()
      {:error, msg} ->
        {:error, msg}
    end
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
