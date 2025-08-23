module Destiny
  class ItemCategory < ManifestEntry
    def self.payload_to_attributes(payload)
      super(payload).merge({
        item_type: :grantDestinyItemType,
        item_sub_type: :grantDestinySubType,
        guardian_type: :grantDestinyClass,
        breaker_type: :grantDestinyBreakerType,
        is_plug: :isPlug
      })
    end
  end
end
