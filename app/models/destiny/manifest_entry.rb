module Destiny
  class ManifestEntry < ApplicationRecord
    self.abstract_class = true

    def self.import_collection(manifest, updates: nil)
      Rails.logger.info("Importing #{self}...")

      manifest.each do |payload|
        payload.deep_symbolize_keys!

        self.import_entry(payload, updates: updates)
        self.link_associations(payload)
      end

      Rails.logger.info("Done.")
    end

    def self.import_entry(payload, updates: nil)
      fields = self.payload_to_attributes(payload).to_h do |key, mappings|
        [ key, payload.dig(*mappings) ]
      end

      fields.merge!(updates) if updates.present?

      self.upsert(fields, unique_by: self.unique_keys)
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
