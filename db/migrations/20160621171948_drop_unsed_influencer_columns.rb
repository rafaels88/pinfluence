Hanami::Model.migration do
  up do
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
  end
end
