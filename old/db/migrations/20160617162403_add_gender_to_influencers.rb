Hanami::Model.migration do
  change do
    add_column :influencers, :gender, String, null: true
  end
end
