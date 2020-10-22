defmodule Timemanager.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :time, :naive_datetime, null: false, reuired: true
      add :status, :boolean, default: true, null: false, reuired: true
      add :user, references(:users, on_delete: :delete_all), null: false, reuired: true

      timestamps()
    end

    create index(:clocks, [:user])
  end
end
