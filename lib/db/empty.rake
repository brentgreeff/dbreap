namespace :db do
  desc "Deletes everything in the database."
  task :empty => :environment do
    ActiveRecord::Base.establish_connection
    @connection = ActiveRecord::Base.connection
    
    tables = @connection.tables - ['schema_migrations']
    
    for table in tables
      @connection.delete("DELETE FROM %s" % table)
    end
  end
end
