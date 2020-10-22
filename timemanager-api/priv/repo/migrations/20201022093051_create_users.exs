defmodule Timemanager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false, reuired: true
      add :email, :string, null: false, reuired: true

      timestamps()
    end

  end
end
