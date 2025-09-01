module Destiny
  class InventoryItem < ManifestEntry
    has_many :inventory_item_traits, foreign_key: :inventory_item_hash, primary_key: :bungie_hash
    has_many :traits, through: :inventory_item_traits
    belongs_to :inventory_bucket, foreign_key: :inventory_bucket_hash, primary_key: :bungie_hash

    def self.payload_to_attributes(payload)
      super(payload).merge({
        flavour_text: :flavorText,
        guardian_type: :classType,
        tier_type: :tierType,
        breaker_type: :breakerType,
        is_equippable: :equippable,
        is_featured: :isFeaturedItem,
        is_holofoil: :isHolofoil,
        is_adept: :isAdept,
        inventory_bucket_hash: [:inventory, :bucketTypeHash]
      })
    end

    def self.link_associations(payload)
      if payload.key?(:traitHashes)
        Destiny::InventoryItemTrait.where(inventory_item_hash: payload[:hash]).delete_all

        payload[:traitHashes].each do |trait_hash|
          Destiny::InventoryItemTrait.create!({
            inventory_item_hash: payload[:hash],
            trait_hash: trait_hash
          })
        end
      end
    end
  end
end
