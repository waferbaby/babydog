Rails.application.configure do
  config.action_controller.allow_forgery_protection = false
  config.action_controller.raise_on_missing_callback_actions = true
  config.action_dispatch.show_exceptions = :rescuable
  config.active_support.deprecation = :stderr
  config.cache_store = :null_store
  config.consider_all_requests_local = true
  config.eager_load = ENV["CI"].present?
  config.enable_reloading = false
  config.public_file_server.headers = { "cache-control" => "public, max-age=3600" }
end
