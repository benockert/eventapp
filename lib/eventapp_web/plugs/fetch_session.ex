defmodule EventappWeb.Plugs.FetchSession do
  import Plug.Conn

  def init(args), do: args

  def call(conn, _args) do
    user = Eventapp.Users.get_user_by_id(get_session(conn, :user_id) || -1)
    if user do
      assign(conn, :current_user, user)
    else
      #if user can't be found, do not assign a user to the current session; prompting login
      assign(conn, :current_user, nil)
    end
  end
end
