Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id

      column :name, String, null: false
      column :email, String, null: false
      column :password, String, null: false
      column :created_at, Time, null: false
      column :updated_at, Time, null: false
    end
  end
end
