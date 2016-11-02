Hanami::Model.migration do
  change do
    create_table :locations do
      primary_key :id

      column :address, String, null: false
      column :latlng, String, null: false
      column :density, Integer, null: false, default: 1
      column :moment_id, Integer, null: false
      column :created_at, Time, null: false
      column :updated_at, Time, null: false
    end
  end
end
