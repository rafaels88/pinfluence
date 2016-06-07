Hanami::Model.migration do
  change do
    create_table :influencers do
      primary_key :id

      column :name, String, null: false
      column :location, String, null: false
      column :begin_at, Time, null: false
      column :end_at, Time, null: true
      column :level, Integer, null: false, default: 3
      column :created_at, Time, null: false
      column :updated_at, Time, null: false
    end
  end
end
