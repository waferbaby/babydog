module Destiny
  class InventoryItemInstance < Base
    belongs_to :membership, foreign_key: :membership_hash, primary_key: :membership_hash
    has_one :inventory_item, foreign_key: :bungie_hash, primary_key: :bungie_hash
    has_many :inventory_item_categories, foreign_key: :inventory_item_hash, primary_key: :bungie_hash
    has_many :categories, class_name: "ItemCategory", through: :inventory_item_categories

    delegate :bungie_hash, :name, :description, :icon_url, :has_icon?, to: :inventory_item

    ItemFilters.all.each do |filters|
      filters.each { |key, name| scope key.to_s.pluralize.to_sym, -> { joins(:categories).merge(ItemCategory.send(key)) } }
    end

    def self.payload_to_attributes(payload)
      {
        bungie_hash: :itemHash,
        instance_hash: :itemInstanceId,
        inventory_bucket_hash: :bucketHash,
        quantity: :quantity,
        location: :location,
        bind_status: :bindStatus,
        is_lockable: :lockable,
        override_style_hash: :overrideStyleItemHash
      }
    end

    def self.unique_keys
      [ :membership_hash, :bungie_hash ]
    end
  end
end
