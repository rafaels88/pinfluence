Hanami::Model.migration do
  up do
    add_column :events, :earliest_date, Date

    # backfill
    execute 'UPDATE events SET earliest_date=sub.earliest_year_date FROM ' \
            "(SELECT id, to_date(cast(events.earliest_year as varchar), 'YYYY') as earliest_year_date " \
            'FROM events) as sub WHERE events.id = sub.id'

    alter_table :events do
      drop_column :earliest_year
    end
  end

  down do; end
end
