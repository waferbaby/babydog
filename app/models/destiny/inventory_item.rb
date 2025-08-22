module Destiny
  class InventoryItem < ManifestEntry
    def self.payload_to_update_params(payload)
      {
        name: payload.dig(:displayProperties, :name),
        description: payload.dig(:displayProperties, :description),
        flavour_text: payload[:flavorText],
        item_type: payload[:itemType],
        item_subtype: payload[:itemSubtype],
        guardian_type: payload[:classType],
        tier_type: payload[:tierType],
        breaker_type: payload[:breakerType],
        is_equippable: payload[:isEquippable],
        is_featured: payload[:isFeatured],
        is_holofoil: payload[:isHolofoil],
        is_adept: payload[:isAdept],
        is_redacted: payload[:redacted],
        is_blacklisted: payload[:blacklisted]
      }
    end
  end
end
