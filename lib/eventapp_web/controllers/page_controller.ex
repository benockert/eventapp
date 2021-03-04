defmodule EventappWeb.PageController do
  use EventappWeb, :controller

  def index(conn, _params) do
    # makes @posts available to the index page
    posts = Eventapp.Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end
end
