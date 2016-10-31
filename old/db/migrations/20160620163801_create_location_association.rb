Hanami::Model.migration do
  up do
    create_table :locations do
      primary_key :id
      foreign_key :influencer_id, :influencers, on_delete: :cascade, null: false

      column :name, String, null: false
      column :latlng, String, null: false
      column :begin_in, Integer, null: false
      column :end_in, Integer, null: true
      column :created_at, Time, null: false
      column :updated_at, Time, null: false
    end
  end

  down do
    drop_table :locations
  end
end
