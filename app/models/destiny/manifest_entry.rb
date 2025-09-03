module Destiny
  class ManifestEntry < ApplicationRecord
    self.abstract_class = true

    def self.import_manifest(manifest)
      Rails.logger.info("Importing #{self}...")

      manifest.values.each do |payload|
        payload.deep_symbolize_keys!

        updates = self.payload_to_attributes(payload).to_h do |key, fields|
          [ key, payload.dig(*fields) ]
        end

        self.import_entry(updates)
        self.link_associations(payload)
      end

      Rails.logger.info("Done.")
    end

    def self.import_entry(updates)
      self.upsert(updates, unique_by: self.unique_keys)
    end

    private

    def self.payload_to_attributes(payload)
      {
        bungie_hash: :hash,
        index: :index,
        name: [ :displayProperties, :name ],
        description: [ :displayProperties, :description ],
        is_redacted: :redacted,
        is_blacklisted: :blacklisted
      }
    end

    def self.payload_to_associations(payload)
      {}
    end

    def self.link_associations(payload)
    end

    def self.unique_keys
      :bungie_hash
    end
  end
end
