defmodule Timemanager.Repo.Migrations.CreateWorkingtimes do
  use Ecto.Migration

  def change do
    create table(:workingtimes) do
      add :start, :naive_datetime, null: false, reuired: true
      add :end, :naive_datetime, null: false, reuired: true
      add :user, references(:users, on_delete: :delete_all), null: false, reuired: true

      timestamps()
    end

    create index(:workingtimes, [:user])
  end
end
