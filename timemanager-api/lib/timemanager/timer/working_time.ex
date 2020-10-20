defmodule Timemanager.Timer.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  alias Timemanager.Account.User

  schema "workingtimes" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    field :user, :id

    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user])
    |> validate_required([:start, :end, :user])
    |> cast_assoc(:users)
  end
end
