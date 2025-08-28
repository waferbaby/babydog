module Destiny
  class InventoryItem < ManifestEntry
    has_many :inventory_item_traits, foreign_key: :trait_hash
    has_many :traits, through: :inventory_item_traits

    def self.payload_to_attributes(payload)
      super(payload).merge({
        flavour_text: :flavorText,
        guardian_type: :classType,
        tier_type: :tierType,
        breaker_type: :breakerType,
        is_equippable: :equippable,
        is_featured: :isFeaturedItem,
        is_holofoil: :isHolofoil,
        is_adept: :isAdept
      })
    end
  end
end
