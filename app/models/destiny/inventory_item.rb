module Destiny
  class InventoryItem < ManifestEntry
    has_many :inventory_item_traits, foreign_key: :inventory_item_hash, primary_key: :bungie_hash
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

    def self.link_associations(payload)
      if payload.key?(:traitHashes)
        payload[:traitHashes].each do |trait_hash|
          Destiny::InventoryItemTrait.upsert({
            inventory_item_hash: payload[:hash],
            trait_hash: trait_hash
          }, unique_by: [:inventory_item_hash, :trait_hash])
        end
      end
    end
  end
end
