Hanami::Model.migration do
  change do
    create_table :people do
      primary_key :id

      column :name, String, null: false
      column :gender, String, null: false
      column :created_at, Time, null: false
      column :updated_at, Time, null: false
    end
  end
end
