defmodule EventappWeb.PostController do
  use EventappWeb, :controller

  alias Eventapp.Posts
  alias Eventapp.Posts.Post

  alias Eventapp.Comments
  alias Eventapp.Responses

  # we need the post first before we perform any actions on it
  plug :fetch_post when action not in [:index, :new, :create]

  def fetch_post(conn, _args) do
    id = conn.params["id"]
    post = Posts.get_post!(id)
    assign(conn, :post, post)
  end

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    post_params = post_params
    |> Map.put("user_id", conn.assigns[:current_user].id)
    case Posts.create_post(post_params) do
      {:ok, post} ->
        Responses.create_responses(post)
        conn
        |> put_flash(:info, "Event created successfully. Email the following link to your
        invitees: https://events.benockert.site/events/#{post.id}")
        |> redirect(to: Routes.post_path(conn, :show, post))
      # error creating event
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
      # error for invalid invitee email
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: Routes.post_path(conn, :new))
    end
  end

  # gets all of the current comments and responses of this event
  def show(conn, %{"id" => _id}) do
    post = Posts.load_resources(conn.assigns[:post])
    comment = %Comments.Comment{
      post_id: post.id,
      user_id: current_user_id(conn),
    }
    new_comment = Comments.change_comment(comment)
    response = %Responses.Response{
      post_id: post.id,
      user_id: current_user_id(conn),
      response: "NO"
    }
    new_response = Responses.change_response(response)
    render(conn, "show.html", post: post, new_comment: new_comment, new_response: new_response)
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    changeset = Posts.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Event updated successfully. Email the following link to any new
        invitees: https://events.benockert.site/events/#{post.id}")
        |> redirect(to: Routes.post_path(conn, :show, post))
      # error updating post
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
      # error for invalid invitee email
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: Routes.post_path(conn, :edit, post))
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
