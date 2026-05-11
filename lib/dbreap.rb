require_relative "dbreap/version"

module Dbreap
  SKIP_TABLES = %w[schema_migrations ar_internal_metadata].freeze
end

require_relative "dbreap/empty"
require_relative "dbreap/reap"
require_relative "dbreap/railtie" if defined?(Rails::Railtie)
