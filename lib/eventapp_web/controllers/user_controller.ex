defmodule EventappWeb.UserController do
  use EventappWeb, :controller

  alias Eventapp.Users
  alias Eventapp.Users.User
  alias Eventapp.Pictures

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  # saves the photo given when creating a user, or sets it to the default
  # stock photo if no picture is given
  def save_photo(params, conn) do
    pic = params["picture"]
    if pic do
      {:ok, hash} = Pictures.save_picture(pic.filename, pic.path)
      params
      |> Map.put("user_id", conn.assigns[:current_user].id)
      |> Map.put("picture_hash", hash)
    else
      hash = Pictures.hash("stock.jpg")
      params |> Map.put("picture_hash", hash)
    end
  end

  def create(conn, %{"user" => user_params}) do
    # sets the hash of the picture
    user_params = user_params
    |> save_photo(conn)

    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully. Please proceed to login.")
        |> redirect(to: Routes.user_path(conn, :show, user))
      # generic error with creating a user
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
      # error message to display (if error with creating a user i.e. invalid email or duplicate)
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: Routes.user_path(conn, :new))
    end
  end

  # loads the profile picture of the user with the given id
  def picture(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _name, data} = Pictures.load_picture(user.picture_hash)
    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, data)
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)
    pic = user_params["picture"]

    user_params = if pic do
      {:ok, _hash} = Pictures.delete_picture(user.picture_hash)
      {:ok, hash} = Pictures.save_picture(pic.filename, pic.path)
      Map.put(user_params, "picture_hash", hash)
    else
      user_params
    end

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))
        # |> redirect(to: "/events")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _hash} = Pictures.delete_picture(user.picture_hash)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
