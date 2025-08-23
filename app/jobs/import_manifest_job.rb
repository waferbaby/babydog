class ImportManifestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sources = Rails.cache.fetch("babydog/manifests/#{Date.today}") do
      Restiny.download_manifest_json(definitions: [
        Restiny::ManifestDefinition::STAT,
        Restiny::ManifestDefinition::TRAIT,
        Restiny::ManifestDefinition::ITEM_CATEGORY,
        Restiny::ManifestDefinition::INVENTORY_ITEM
      ])
    end

    sources.each do |manifest, file_path|
      object_type = "Destiny::#{manifest.gsub(/Destiny|Definition/, '')}".constantize

      begin
        object_type.import_manifest(JSON.parse(File.read(file_path)))
      rescue JSON::ParserError => e
        Rails.logger.error("Failed to parse #{file_path}")
      end
    end
  end
end
