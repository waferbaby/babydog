module Destiny
  class InventoryItem < ManifestEntry
    def self.payload_to_attributes(payload)
      super(payload).merge({
        flavour_text: :flavorText,
        item_type: :itemType,
        item_subtype: :itemSubtype,
        guardian_type: :classType,
        tier_type: :tierType,
        breaker_type: :breakerType,
        is_equippable: :isEquippable,
        is_featured: :isFeaturedItem,
        is_holofoil: :isHolofoil,
        is_adept: :isAdept
      })
    end
  end
end
