class ImportManifestJob < ApplicationJob
  queue_as :default

  def perform(*args)

    sources = Rails.cache.fetch('babydog_manifests_now') do
      Restiny.download_manifest_json(definitions: [
        Restiny::ManifestDefinition::ITEM_CATEGORY,
        Restiny::ManifestDefinition::INVENTORY_ITEM
      ])
    end

    sources.each do |manifest, file_path|
      object_type = "Destiny::#{manifest.gsub(/Destiny|Definition/, '')}".constantize

      begin
        data = JSON.parse(File.read(file_path))

        data.values.each do |payload|
          object_type.import(payload)
        end
      rescue JSON::ParserError => e
        Rails.logger.error("Failed to parse #{file_path}")
      end
    end
  end
end
