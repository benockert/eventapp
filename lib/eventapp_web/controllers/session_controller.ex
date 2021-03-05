defmodule EventappWeb.SessionController do
  use EventappWeb, :controller

  def create(conn, %{"name" => name}) do
    user = Eventapp.Users.get_user_by_name(name)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.username}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed. User \'#{name}\' not found.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Successfully logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
