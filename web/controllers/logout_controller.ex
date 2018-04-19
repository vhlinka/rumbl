defmodule Rumbl.LogoutController do
    use Rumbl.Web, :controller
#
# TODO: This controller is a hack to fix a non-reponsive link issue with sample book code
#
    def index(conn, _params) do
      conn
      |> Rumbl.Auth.logout()
      |> redirect(to: page_path(conn, :index))
    end


end
