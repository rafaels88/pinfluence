Hanami::Model.migration do
  change do
    alter_table :moments do
      rename_column :influencer_id, :person_id
      set_column_allow_null :person_id
      set_column_type :person_id, "INTEGER USING person_id::integer"
      drop_column :influencer_type

      add_foreign_key [:person_id], :people, on_delete: :cascade, null: true
    end
  end
end
