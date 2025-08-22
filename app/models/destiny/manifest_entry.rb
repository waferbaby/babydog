module Destiny
  class ManifestEntry < ApplicationRecord
    self.abstract_class = true

    def self.import(payload)
      payload.deep_symbolize_keys!

      item = self.find_or_create_by!(bungie_hash: payload[:hash])
      item.update!(self.payload_to_update_params(payload))
    end

    private

    def self.payload_to_update_params(payload)
      {}
    end
  end
end
