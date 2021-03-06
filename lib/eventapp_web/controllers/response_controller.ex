defmodule EventappWeb.ResponseController do
  use EventappWeb, :controller

  alias Eventapp.Posts
  alias Eventapp.Responses
  alias Eventapp.Responses.Response

  def index(conn, _params) do
    responses = Responses.list_responses()
    render(conn, "index.html", responses: responses)
  end

  def new(conn, _params) do
    changeset = Responses.change_response(%Response{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"response" => response_params}) do
    response_params = response_params
    |> Map.put("user_id", current_user_id(conn))
    post = response_params
    |> Map.get("post_id")
    |> Posts.get_post!()

    case Responses.create_response(response_params) do
      {:ok, response} ->
        conn
        |> put_flash(:info, "Response updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))
        # redirect to the same post rather than the new response

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    response = Responses.get_response!(id)
    render(conn, "show.html", response: response)
  end

  def edit(conn, %{"id" => id}) do
    response = Responses.get_response!(id)
    changeset = Responses.change_response(response)
    render(conn, "edit.html", response: response, changeset: changeset)
  end

  def update(conn, %{"id" => id, "response" => response_params}) do
    response = Responses.get_response!(id)

    case Responses.update_response(response, response_params) do
      {:ok, response} ->
        conn
        |> put_flash(:info, "Response updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, Posts.get_post!(response.id)))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", response: response, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    response = Responses.get_response!(id)
    {:ok, _response} = Responses.delete_response(response)

    conn
    |> put_flash(:info, "Response deleted successfully.")
    |> redirect(to: Routes.response_path(conn, :index))
  end
end
