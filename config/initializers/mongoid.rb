Mongoid.configure do
  target_version = "9.0"

  config.load_defaults target_version
end

Rails.application.config.middleware.use(Mongo::QueryCache::Middleware)

ActiveSupport.on_load(:active_job) do
   include Mongo::QueryCache::Middleware::ActiveJob
end
