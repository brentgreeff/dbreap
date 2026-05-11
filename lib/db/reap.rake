# frozen_string_literal: true

namespace :db do
  desc 'Create YAML seed fixtures from data in an existing database. Set FIXTURES=ALL or FIXTURES=table1,table2.'
  task reap: :environment do
    if ENV['FIXTURES'].nil?
      puts 'Please specify FIXTURES: ALL or a comma-separated list of table names'
      exit
    end

    tables = ENV['FIXTURES'] == 'ALL' ? ActiveRecord::Base.connection.tables : ENV['FIXTURES'].split(',').map(&:strip)
    tables -= Dbreap::SKIP_TABLES

    FileUtils.mkdir_p("#{Rails.root}/db/fixtures/#{Rails.env}")

    tables.each(&Dbreap::Reap.method(:write_fixture))
  end
end
