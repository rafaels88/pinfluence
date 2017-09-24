Hanami::Model.migration do
  change do
    add_column :events, :earliest_year, Integer, null: true
  end
end
