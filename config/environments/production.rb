require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.action_controller.perform_caching = true
  config.active_job.queue_adapter = :solid_queue
  config.active_record.attributes_for_inspect = [ :id ]
  config.active_record.dump_schema_after_migration = false
  config.active_support.report_deprecations = false
  config.assume_ssl = true
  config.cache_store = :solid_cache_store
  config.consider_all_requests_local = false
  config.eager_load = true
  config.enable_reloading = false
  config.force_ssl = true
  config.i18n.fallbacks = true
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }
  config.silence_healthcheck_path = "/up"
  config.solid_queue.connects_to = { database: { writing: :queue } }
end
