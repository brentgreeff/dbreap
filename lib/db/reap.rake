namespace :db do
  desc 'Create YAML seed fixtures from data in an existing database.  
  Defaults to development database. Set Rails.env to override.'
  task :reap => :environment do
    skip_tables = ["schema_migrations"]
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
      i = "000"
      File.open("#{Rails.root}/db/fixtures/#{Rails.env}/#{table_name}.yml", 'w') do |file|
        data = ActiveRecord::Base.connection.select_all("SELECT * FROM %s" % table_name)
        file.write data.inject({}) { |hash, record|
          hash["#{table_name}_#{i.succ!}"] = record
          hash
        }.to_yaml
      end
      puts "Completed extract for #{table_name}"
    end
  end
end
