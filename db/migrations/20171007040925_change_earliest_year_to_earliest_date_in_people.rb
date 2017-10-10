Hanami::Model.migration do
  up do
    add_column :people, :earliest_date, Date

    # backfill
    execute 'UPDATE people SET earliest_date=sub.earliest_year_date FROM ' \
            "(SELECT id, to_date(cast(people.earliest_year as varchar), 'YYYY') as earliest_year_date " \
            'FROM people) as sub WHERE people.id = sub.id'

    alter_table :people do
      drop_column :earliest_year
    end
  end

  down do; end
end
