
require 'active_record/fixtures'
FIXTURES_PATHS = ["db/fixtures", "db/fixtures/#{Rails.env}"]

for path in FIXTURES_PATHS
  Dir.glob("#{RAILS_ROOT}/#{path}/" + '*.yml').each do |file|
    Fixtures.create_fixtures(path, File.basename(file, '.*'))
  end
end
