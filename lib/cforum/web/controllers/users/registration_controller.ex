defmodule Cforum.Web.Users.RegistrationController do
  use Cforum.Web, :controller

  plug Cforum.Plug.EnsureAnonymous

  alias Cforum.Accounts.Users
  alias Cforum.Accounts.User

  def new(conn, _params) do
    changeset = User.register_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.register_user(user_params) do
      {:ok, user} ->
        Cforum.Web.UserMailer.confirmation_mail(user)
        |> Cforum.Mailer.deliver_later

        conn
        |> put_flash(:info, gettext("Account successfully created. Please follow the confirmation instructions we send you via mail."))
        |> redirect(to: forum_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def confirm(conn, %{"token" => token}) do
    case Users.confirm_user(token) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Account successfully confirmed!"))
        |> Cforum.Auth.login(user)
        |> redirect(to: forum_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, gettext("Oops, something went wrong!"))
        |> redirect(to: forum_path(conn, :index))
    end
  end


end
