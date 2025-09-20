module Destiny
  class InventoryItem < Base
    has_many :inventory_item_traits, foreign_key: :inventory_item_hash, primary_key: :bungie_hash
    has_many :traits, through: :inventory_item_traits

    has_many :inventory_item_categories, foreign_key: :inventory_item_hash, primary_key: :bungie_hash
    has_many :categories, class_name: "ItemCategory", through: :inventory_item_categories

    belongs_to :bucket, class_name: "InventoryBucket", foreign_key: :inventory_bucket_hash, primary_key: :bungie_hash

    ItemFilters.all.each do |filters|
      filters.each { |key, name| scope key.to_s.pluralize.to_sym, -> { joins(:categories).merge(ItemCategory.send(key)) } }
    end

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
        inventory_bucket_hash: [ :inventory, :bucketTypeHash ],
        has_icon: [ :displayProperties, :hasIcon ],
        icon_url: [ :displayProperties, :icon ],
        high_res_icon_url: [ :displayProperties, :highResIcon ]
      })
    end

    def self.link_associations(payload)
      if payload.key?(:traitHashes)
        Destiny::InventoryItemTrait.where(inventory_item_hash: payload[:hash]).delete_all

        payload[:traitHashes].each do |trait_hash|
          Destiny::InventoryItemTrait.upsert(inventory_item_hash: payload[:hash], trait_hash: trait_hash)
        end
      end

      if payload.key?(:itemCategoryHashes)
        Destiny::InventoryItemCategory.where(inventory_item_hash: payload[:hash]).delete_all

        payload[:itemCategoryHashes].each do |category_hash|
          Destiny::InventoryItemCategory.upsert(inventory_item_hash: payload[:hash], category_hash: category_hash)
        end
      end
    end
  end
end
