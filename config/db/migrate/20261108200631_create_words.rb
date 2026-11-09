# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :words do
      primary_key :id
      column :name, String, null: false
      column :normalized_name, String, null: false
      index :normalized_name, unique: true
    end
  end
end
