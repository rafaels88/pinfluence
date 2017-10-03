Hanami::Model.migration do
  up do
    add_column :moments, :date_begin, Date
    add_column :moments, :date_end, Date

    # backfill_all_dates
    execute 'UPDATE moments SET date_begin=sub.year_begin_date, date_end=sub.year_end_date FROM ' \
            "(SELECT id, to_date(cast(moments.year_begin as varchar), 'YYYY') as year_begin_date, " \
            "to_date(cast(moments.year_end as varchar), 'YYYY') as year_end_date FROM moments) as sub " \
            'WHERE moments.id = sub.id'

    alter_table :moments do
      drop_column :year_begin
      drop_column :year_end
    end
  end

  down do; end
end
