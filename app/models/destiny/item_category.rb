module Destiny
  class ItemCategory < ManifestEntry
    def self.payload_to_attributes(payload)
      super(payload).merge({
        name: [:displayProperties, :name],
        description: [:displayProperties, :description],
        item_type: :grantDestinyItemType,
        item_sub_type: :grantDestinySubType,
        guardian_type: :grantDestinyClass,
        breaker_type: :grantDestinyBreakerType,
        is_plug: :isPlug,
        is_deprecated: :deprecated,
        is_redacted: :redacted,
        is_blacklisted: :blacklisted
      })
    end
  end
end
