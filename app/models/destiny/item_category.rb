module Destiny
  class ItemCategory < ManifestEntry
    def self.payload_to_attributes(payload)
      super(payload).merge({
        is_plug: :isPlug
      })
    end
  end
end
