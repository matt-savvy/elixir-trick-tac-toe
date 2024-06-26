defmodule TrickTacToeWeb.PageController do
  use TrickTacToeWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def rules(conn, _params) do
    render(conn, :rules)
  end
end
