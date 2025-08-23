module Destiny
  class ManifestEntry < ApplicationRecord
    self.abstract_class = true

    def self.import_manifest(manifest)
      manifest.deep_symbolize_keys!

      associations = {}

      manifest.values.each do |payload|
        associations.merge(payload_to_associations(payload))
        self.import_entry(payload)
      end
    end

    def self.import_entry(payload)
      path = File.join("/tmp/#{self.to_s.downcase}")
      Dir.mkdir(path) unless Dir.exist?(path)
      File.write(File.join(path, "#{payload[:hash]}.json"), payload)

      item = self.find_or_create_by!(bungie_hash: payload[:hash])

      updates = self.payload_to_attributes(payload).to_h do |key, fields|
        [key, payload.dig(*fields)]
      end

      item.update!(updates)
    end

    private

    def self.payload_to_attributes(payload)
      {
        index: :index,
        name: [:displayProperties, :name],
        description: [:displayProperties, :description],
        is_redacted: :redacted,
        is_blacklisted: :blacklisted
      }
    end

    def self.payload_to_associations(payload)
      {}
    end
  end
end
