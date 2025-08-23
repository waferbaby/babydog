module Destiny
  class ManifestEntry < ApplicationRecord
    self.abstract_class = true

    def self.import_manifest(manifest)
      manifest.deep_symbolize_keys!

      manifest.values.each do |payload|
        self.import_entry(payload)
      end
    end

    def self.import_entry(payload)
      item = self.find_or_create_by!(bungie_hash: payload[:hash])

      updates = self.payload_to_attributes(payload).to_h do |key, fields|
        [key, payload.dig(*fields)]
      end

      item.update!(updates)

      self.link_associations(payload)
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

    def self.link_associations(payload)
    end
  end
end
