Hanami::Model.migration do
  change do
    add_column :moments, :event_id, Integer, null: true

    alter_table :moments do
      add_foreign_key [:event_id], :events, on_delete: :cascade, null: true
    end
  end
end
