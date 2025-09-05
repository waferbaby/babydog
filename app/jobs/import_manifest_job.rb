class ImportManifestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sources = Rails.cache.fetch("babydog/manifests/#{Date.today}") do
      Restiny.download_manifest_json(definitions: [
        Restiny::ManifestDefinition::STAT,
        Restiny::ManifestDefinition::STAT_GROUP,
        Restiny::ManifestDefinition::DAMAGE_TYPE,
        Restiny::ManifestDefinition::ENERGY_TYPE,
        Restiny::ManifestDefinition::TRAIT,
        Restiny::ManifestDefinition::ITEM_CATEGORY,
        Restiny::ManifestDefinition::PLUG_SET,
        Restiny::ManifestDefinition::INVENTORY_BUCKET,
        Restiny::ManifestDefinition::INVENTORY_ITEM
      ])
    end

    sources.each do |manifest, file_path|
      object_type = "Destiny::#{manifest.gsub(/Destiny|Definition/, '')}".constantize

      begin
        manifest = JSON.parse(File.read(file_path))
        object_type.import_collection(manifest.values)
      rescue JSON::ParserError => e
        Rails.logger.error("Failed to parse #{file_path}")
      end
    end
  end
end
