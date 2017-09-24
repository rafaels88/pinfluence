Hanami::Model.migration do
  change do
    alter_table :events do
      drop_column :kind
    end
  end
end
