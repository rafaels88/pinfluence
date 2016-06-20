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

    InfluencerRepository.all.each do |influencer|
      location = Location.new(
        name: influencer.location,
        latlng: influencer.latlng,
        begin_in: influencer.begin_at,
        end_in: influencer.end_at,
        influencer_id: influencer.id
      )

      LocationRepository.create(location)
    end

    alter_table :influencers do
      drop_column :location
      drop_column :latlng
      drop_column :begin_at
      drop_column :end_at
    end
  end

  down do
    add_column :influencers, :location, String, null: false
    add_column :influencers, :latlng, String, null: false
    add_column :influencers, :begin_at, Integer, null: false
    add_column :influencers, :end_at, Integer, null: true

    drop_table :locations
  end
end
