# frozen_string_literal: true

module Dbreap
  module Reap
    def self.build_yml(table_name, connection: ActiveRecord::Base.connection)
      raw = fetch_rows(table_name, connection:)

      rows = raw.each_with_index.with_object({}) do |(row, i), accum|
        key = "#{table_name}_#{format('%03d', i + 1)}"
        accum[key] = row.transform_values { |v| cast_value(v) }
      end
      Psych.dump(rows, line_width: -1)
    end

    def self.fetch_rows(table_name, connection: ActiveRecord::Base.connection)
      quoted = connection.quote_table_name(table_name)
      connection.select_all("SELECT * FROM #{quoted} ORDER BY id")
    rescue ActiveRecord::StatementInvalid
      connection.select_all("SELECT * FROM #{quoted} ORDER BY 1")
    end

    def self.cast_value(value)
      return value unless value.is_a?(String) && value.match?(/\A[\[{]/)

      JSON.parse(value)
    rescue JSON::ParserError
      value
    end

    def self.write_fixture(table_name, root: Rails.root, env: Rails.env)
      path = "#{root}/db/fixtures/#{env}/#{table_name}.yml"
      yaml = build_yml(table_name)
      File.write(path, yaml)
      puts "Reaped #{table_name}"
    end
  end
end
