# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require File.expand_path('dummy/config/environment', __dir__)

require 'rspec/rails'
require 'factory_bot_rails'
require 'dbreap'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

load File.expand_path('dummy/db/schema.rb', __dir__)

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.include FactoryBot::Syntax::Methods
end
