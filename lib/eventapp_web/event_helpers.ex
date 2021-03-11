defmodule EventappWeb.Helpers do

  def current_user_id(conn) do
    user = conn.assigns[:current_user]
    user && user.id
  end

end
