defmodule EventappWeb.SessionController do
  use EventappWeb, :controller

  def create(conn, %{"email" => email}) do
    user = Eventapp.Users.get_user_by_email(email)
    if user do
      if user.username !== "" do
        # the user has been completely set up
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back #{user.username}!")
        |> redirect(to: Routes.page_path(conn, :index))
      else
        # need to finish completing user profile
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome! Please complete your account")
        |> redirect(to: Routes.user_path(conn, :edit, user)) #TODO add an update page
      end
    else
      # no user with the given email exists
      conn
      |> put_flash(:error, "Login failed. User with email \'#{email}\' not found.")
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
