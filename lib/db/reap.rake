namespace :db do
  desc 'Create YAML seed fixtures from data in an existing database.
  Defaults to development database. Set Rails.env to override.'
  task reap: :environment do
    skip_tables = %w{schema_migrations ar_internal_metadata}
    ActiveRecord::Base.establish_connection

    if ENV['FIXTURES'].nil?
      puts 'Please specify FIXTURES : (ALL) if you want all'
      exit
    end

    if ENV['FIXTURES'] == 'ALL'
      tables = ActiveRecord::Base.connection.tables
    else
      tables = ENV['FIXTURES'].split(/,/)
    end
    tables -= skip_tables

    skip_tables.each do |table_name|
      puts "Skipped export for #{table_name}"
    end

    tables.each do |table_name|
      path = "#{Rails.root}/db/fixtures/#{Rails.env}/#{table_name}.yml"

      File.open(path, 'w') do |file|
        yaml = build_yml(table_name)
        file.write (yaml.gsub %r{\s+$}, '') + "\n"
      end
      puts "Completed extract for #{table_name}"
    end
  end
end

def build_yml(table_name)
  i = "000"
  select_all(table_name).inject({}) do |accum, hash_of_obj|

    hash_of_obj = hash_of_obj.reduce({}) do |new_obj, (column, value)|
      new_obj[column] = build_value(value)
      new_obj
    end
    accum["#{table_name}_#{i.succ!}"] = hash_of_obj
    accum
  end.to_yaml
end

def select_all(table_name)
  begin
    select_exec("SELECT * FROM %s ORDER BY id" % table_name)
  rescue ActiveRecord::StatementInvalid => e
    # some models have no ID
    select_exec("SELECT * FROM %s ORDER BY 1" % table_name)
  end
end

def select_exec(...)
  ActiveRecord::Base.connection.select_all(...)
end

def build_value(value)
  its_probably_json = JSON.parse(value)
  return [] if its_probably_json.empty?
  its_probably_json
rescue JSON::ParserError, TypeError, NoMethodError
  value
end
