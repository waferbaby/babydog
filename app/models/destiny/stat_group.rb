module Destiny
  class StatGroup < ManifestEntry
    def self.payload_to_attributes(payload)
      {
        bungie_hash: :hash
      }
    end
  end
end
