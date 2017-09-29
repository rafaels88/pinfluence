Hanami::Model.migration do
  change do
    add_column :people, :earliest_year, Integer, null: true
  end
end
