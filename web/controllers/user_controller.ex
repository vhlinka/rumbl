defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  alias Rumbl.User

  plug :authenticate when action in [:index, :show]

#
# modified with authenication logic
#
#  def index(conn, _params) do
#    case authenticate(conn) do
#      %Plug.Conn{halted: true} = conn ->
#        conn
#      conn ->
#        users = Repo.all(Rumbl.User)
#        render conn, "index.html", users: users
#    end
#  end
#
# normal version of index() - which assumes a plug handles the authenication
#
  def index(conn, _params) do
    users = Repo.all(Rumbl.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Rumbl.User, id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
#    changeset = User.changeset(%User{}, user_params)
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
        {:ok, user} ->
          conn
          |> Rumbl.Auth.login(user)
          |> put_flash(:info, "#{user.name} created")
          |> redirect(to: user_path(conn, :index))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset )
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access the requested page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end


end
