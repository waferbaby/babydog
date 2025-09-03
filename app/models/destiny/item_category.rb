module Destiny
  class ItemCategory < ManifestEntry
    has_many :inventory_item_categories, foreign_key: :category_hash, primary_key: :bungie_hash
    has_many :inventory_items, through: :inventory_item_categories

    def self.payload_to_attributes(payload)
      super(payload).merge({
        is_plug: :isPlug
      })
    end
  end
end
