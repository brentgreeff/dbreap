module Dbreap
  module Empty
    def self.call(connection = ActiveRecord::Base.connection)
      tables = connection.tables - Dbreap::SKIP_TABLES
      tables.each { |t| connection.delete("DELETE FROM #{connection.quote_table_name(t)}") }
    end
  end
end
