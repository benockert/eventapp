defmodule EventappWeb.PageControllerTest do
  use EventappWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Events Feed"
  end
end
