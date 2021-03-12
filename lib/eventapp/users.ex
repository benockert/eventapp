defmodule Eventapp.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Eventapp.Repo

  alias Eventapp.Users.User
  alias Eventapp.Pictures

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  #gets user by id
  def get_user_by_id(id), do: Repo.get(User, id)

  #gets user by name
  def get_user_by_name(name) do
    Repo.get_by(User, username: name)
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  # checks that the invitee emails are of valid form
  def check_invitee_email(email) do
    user = get_user_by_email(email)
    if user do
      # the user exists, just return the email
      email
    else
      at? = email
      |> String.contains?("@")

      dot? = email
      |> String.contains?(".")

      if at? && dot? do
        # if the user does not exist yet but the email is in proper form, create a user entry
        photo = Pictures.hash("stock.jpg") #silhouette photo by default
        Repo.insert!(%User{username: "", email: email, picture_hash: photo})
        # return the email for the invitee list
        email
      else
        "INVALID"
      end
    end
  end

  # checks that the email does not already have a user associated with it, and also
  # makes sure it is a valid email
  def validate_email(attrs) do
    email = attrs
    |> Map.get("email")

    user = get_user_by_email(email)
    if user do
      # the user exists, return an error message
      {:error, "User with that email already exists"}
    else
      at? = email
      |> String.contains?("@")

      dot? = email
      |> String.contains?(".")

      if at? && dot? do
        # return ok message
        {:ok, attrs}
      else
        # the email is not valid, return an error message
        {:error, "Invalid email address"}
      end
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    case validate_email(attrs) do
      {:ok, attrs} ->
        %User{}
        |> User.changeset(attrs)
        |> Repo.insert()
      {:error, msg} ->
        {:error, msg}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
