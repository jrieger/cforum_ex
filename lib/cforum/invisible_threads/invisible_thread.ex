defmodule Cforum.InvisibleThreads.InvisibleThread do
  use CforumWeb, :model

  @primary_key {:invisible_thread_id, :id, autogenerate: true}
  @derive {Phoenix.Param, key: :invisible_thread_id}

  schema "invisible_threads" do
    field(:user_id, :id)
    field(:thread_id, :id)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :thread_id])
    |> validate_required([:user_id, :thread_id])
    |> unique_constraint(:user_id, name: :invisible_threads_thread_id_user_id_idx)
  end
end
