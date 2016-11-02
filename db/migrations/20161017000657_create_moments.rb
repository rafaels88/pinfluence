Hanami::Model.migration do
  change do
    create_table :moments do
      primary_key :id

      column :year_begin, Integer, null: false
      column :year_end, Integer
      column :influencer_id, String, null: false
      column :influencer_type, String, null: false
      column :created_at, Time, null: false
      column :updated_at, Time, null: false
    end
  end
end
