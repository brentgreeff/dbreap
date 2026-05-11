require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"

Bundler.require(*Rails.groups)

module DbreapDummy
  class Application < Rails::Application
    config.load_defaults 8.1
    config.eager_load = false
  end
end
