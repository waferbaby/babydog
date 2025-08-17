module Destiny
  class ManifestEntry < ApplicationRecord
    self.abstract_class = true

    def self.import(payload)
      puts self.class
      item = self.find_or_create_by!(bungie_hash: payload[:hash])
      item.update!(self.payload_to_update(payload))
    end

    private

    def self.payload_to_update(payload)
      payload.delete(:hash)
    end
  end
end
