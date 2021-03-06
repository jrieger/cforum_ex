defmodule Cforum.ReadMessages.ReadMessage do
  use CforumWeb, :model

  @primary_key {:read_message_id, :id, autogenerate: true}
  @derive {Phoenix.Param, key: :read_message_id}

  schema "read_messages" do
    field(:user_id, :id)
    field(:message_id, :id)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :message_id])
    |> validate_required([:user_id, :message_id])
    |> unique_constraint(:user_id, name: :read_messages_message_id_user_id_idx)
  end
end
