Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = ENV["CI"].present?
  config.cache_store = :null_store
  config.active_support.deprecation = :stderr
end
