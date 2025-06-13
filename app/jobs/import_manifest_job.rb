class ImportManifestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = Mongo::Client.new([ "localhost:27017" ], database: "babydog_#{ENV["RAILS_ENV"]}")

    manifests = Rails.cache.fetch("babydog_manifest_#{Time.now.strftime('%Y-%m-%d')}") do
      Restiny.download_manifest_json(definitions: Restiny::ManifestDefinition.values)
    end

    manifests.each do |key, manifest_path|
      collection_name = key.gsub(/^Destiny/, "").gsub(/Definition$/, "").underscore.pluralize
      collection = client[collection_name.to_sym]

      logger.info("Importing '#{collection_name}'")

      manifest = JSON.parse(File.read(manifest_path))
      manifest.deep_transform_keys! { |key| key.underscore }

      updates = manifest.to_h do |bungie_id, payload|
        payload.delete("hash")

        [
          :update_one,
          {
            filter: { "_id": bungie_id },
            update: { "$set" => payload },
            upsert: true
          }
        ]
      end

      collection.bulk_write([ updates ]) unless updates.empty?
    end
  end
end
