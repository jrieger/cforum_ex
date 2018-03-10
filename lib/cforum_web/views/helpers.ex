defmodule CforumWeb.Views.Helpers do
  @moduledoc """
  This module contains some helpers for web rendering
  """

  use Phoenix.HTML

  import CforumWeb.Gettext

  alias Cforum.Helpers
  alias Cforum.ConfigManager

  @doc """
  This function formats a date by a format name. It looks up the format itself
  using `Cforum.ConfigManager.uconf`. `name` parameter defaults to `"date_format_default"`.

  ## Examples

      iex> date_format(Timex.DateTime{})
      "2017-01-01 00:00"

      iex> date_format(Timex.DateTime{}, "date_format_default")
      "2017-01-01 00:00"
  """
  def date_format(conn, name \\ "date_format_default") do
    val = Cforum.ConfigManager.uconf(conn, name)
    if Helpers.blank?(val), do: "%d.%m.%Y %H:%M", else: val
  end

  def format_date(conn, date, format \\ "date_format_default"),
    do: Timex.format!(date, date_format(conn, format), :strftime)

  @doc """
  Returns true if a key in a changeset is blank or equal to a specified value. Helper for
  the user configuration and the admin interface, to distinguish between global config values
  and modified config values
  """
  def blank_or_value?(changeset, key, value) do
    field_val = Map.get(changeset, key)
    Helpers.blank?(field_val) || field_val == value
  end

  @doc """
  generates a „sub-form“ in a different namespace: the input fields will be prefixed
  with that namespace. If i.e. called with `field` set to `foo[bar]` the generated
  field names look like this: `foo[bar][baz]`
  """
  def sub_inputs(form, field, _options \\ [], fun) do
    # options =
    #   form.options
    #   |> Keyword.take([:multipart])
    #   |> Keyword.merge(options)

    attr = Map.get(form.data, field) || %{}
    symbolized_attr = Enum.reduce(Map.keys(attr), %{}, fn key, map -> Map.put(map, String.to_atom(key), attr[key]) end)
    types = Enum.reduce(Map.keys(symbolized_attr), %{}, fn key, map -> Map.put(map, key, :string) end)

    changeset = Ecto.Changeset.cast({symbolized_attr, types}, form.params, Map.keys(symbolized_attr))
    forms = Phoenix.HTML.FormData.to_form(changeset, as: form.name <> "[#{field}]")

    fun.(forms)
  end

  @doc """
  Generates a time tag with the correct `datetime` attribute and the given content
  """
  def time_tag(time, opts, do: content) do
    timestamp = DateTime.to_iso8601(time)
    content_tag(:time, content, Keyword.merge([datetime: timestamp], opts))
  end

  @doc """
  Generates a time tag with the correct `datetime` attribute and the given content
  """
  def time_tag(content, time, opts) do
    timestamp = DateTime.to_iso8601(time)
    content_tag(:time, content, Keyword.merge([datetime: timestamp], opts))
  end

  @doc """
  Renders a localized version of the template.

  Sometimes it is useful to have a localized partial or template, containing blocks of
  HTML and text mixed. `l10n_render/3` tries to render this localized version and falls
  back to the non-localized version, e.g. given locale is `de`,
  `l10n_render(@view_module, "foo.html", assigns)`` first tries to render `foo.de.html`
  and then, when not successful, falls back to `foo.html`.

  ## Parameters

  - `view` - the view module (e.g. `@view_module`)
  - `template` - the template file name
  - `assigns` - assigned variables/values
  """
  def l10n_render(view, template, assigns) do
    locale = Gettext.get_locale(CforumWeb.Gettext)
    val = Phoenix.View.render_existing(view, String.replace_suffix(template, ".html", ".#{locale}.html"), assigns)
    if val == nil, do: Phoenix.View.render(view, template, assigns), else: val
  end

  @doc """
  Try to get a pre-filled author from the conn

  Either by `current_user.username` or by `cforum_author` cookie
  """
  def author_from_conn(%{assigns: %{current_user: user}}) when not is_nil(user), do: user.username
  def author_from_conn(conn), do: conn.cookies["cforum_author"]

  @doc """
  Try to get the email address from the conn

  Either from user configuration or from `cforum_email` cookie
  """
  def email_from_conn(%{assigns: %{current_user: user}} = conn) when not is_nil(user),
    do: ConfigManager.uconf(conn, "email")

  def email_from_conn(conn), do: conn.cookies["cforum_email"]

  @doc """
  Try to get the homepage address from the conn

  Either from user config or from the `cforum_homepage` cookie
  """
  def homepage_from_conn(%{assigns: %{current_user: user}} = conn) when not is_nil(user),
    do: ConfigManager.uconf(conn, "url")

  def homepage_from_conn(conn), do: conn.cookies["cforum_homepage"]

  @doc """
  Returns the localized medal type name
  """
  def l10n_medal_type("bronze"), do: gettext("bronze medal")
  def l10n_medal_type("silver"), do: gettext("silver medal")
  def l10n_medal_type("gold"), do: gettext("gold medal")
  def l10n_medal_type(v), do: raise(inspect(v))

  def user_link(conn, user, additional_classes \\ [], username \\ "") do
    user_name = if Cforum.Helpers.blank?(username), do: "", else: " #{username}"

    link(
      to: CforumWeb.Router.Helpers.user_path(conn, :show, user),
      title: gettext("user %{user}", user: user.username),
      class: "user-link"
    ) do
      [
        {:safe, "<span class=\"registered-user\""},
        additional_classes,
        {:safe, "\">"},
        {:safe, "<span class=\"visually-hidden\">"},
        gettext("link to profile of"),
        {:safe, "</span>"},
        img_tag(
          Cforum.Accounts.User.avatar_path(user, :thumb),
          class: "avatar",
          alt: gettext("user %{user}", user: user.username)
        ),
        user_name,
        {:safe, "</span>"}
      ]
    end
  end
end
