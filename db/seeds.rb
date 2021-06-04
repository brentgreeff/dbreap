# frozen_string_literal: true

require 'active_record/fixtures'
FIXTURES_PATHS = ["db/fixtures", "db/fixtures/#{Rails.env}"]

for path in FIXTURES_PATHS
  Dir.glob("#{Rails.root}/#{path}/" + '*.yml').each do |file|
    puts File.basename(file, '.*')
    ActiveRecord::FixtureSet.create_fixtures(path, File.basename(file, '.*'))
  end
end
