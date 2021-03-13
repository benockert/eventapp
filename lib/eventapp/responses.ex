defmodule Eventapp.Responses do
  @moduledoc """
  The Responses context.
  """

  import Ecto.Query, warn: false
  alias Eventapp.Repo

  alias Eventapp.Users
  alias Eventapp.Responses.Response


  # creates new default responses
  def create_responses(post) do
    IO.inspect(post.invitees)

    post.invitees
    |> String.split(", ")
    |> Enum.map(fn e -> Repo.insert!(%Response{response: "NO RESPONSE",
                                               user_id: Users.get_user_by_email(e).id,
                                               post_id: post.id}) end)
  end

  @doc """
  Returns the list of responses.

  ## Examples

      iex> list_responses()
      [%Response{}, ...]

  """
  def list_responses do
    Repo.all(Response)
  end

  @doc """
  Gets a single response.

  Raises `Ecto.NoResultsError` if the Response does not exist.

  ## Examples

      iex> get_response!(123)
      %Response{}

      iex> get_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_response!(id), do: Repo.get!(Response, id)

  # checks if the attributes of this response match the post and user id of the given response
  def dup?(attrs, response) do
    Map.get(attrs, "post_id") === Integer.to_string(response.post_id) && Integer.to_string(Map.get(attrs, "user_id")) === Integer.to_string(response.user_id)
  end

  # returns true if the user and post id of the two responses are the same
  def check_duplicates(attrs, responses) do
    responses
    |> Enum.filter(fn resp -> dup?(attrs, resp) end)
    |> Enum.at(0)
  end


  @doc """
  Creates a response.

  ## Examples

      iex> create_response(%{field: value})
      {:ok, %Response{}}

      iex> create_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_response(attrs \\ %{}) do
    # deletes previous responses from the same user on the same post, if any
    duplicate = check_duplicates(attrs, list_responses())
    if duplicate do
      delete_response(duplicate)
    end

    %Response{}
    |> Response.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a response.

  ## Examples

      iex> update_response(response, %{field: new_value})
      {:ok, %Response{}}

      iex> update_response(response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_response(%Response{} = response, attrs) do
    response
    |> Response.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a response.

  ## Examples

      iex> delete_response(response)
      {:ok, %Response{}}

      iex> delete_response(response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_response(%Response{} = response) do
    Repo.delete(response)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking response changes.

  ## Examples

      iex> change_response(response)
      %Ecto.Changeset{data: %Response{}}

  """
  def change_response(%Response{} = response, attrs \\ %{}) do
    Response.changeset(response, attrs)
  end
end
