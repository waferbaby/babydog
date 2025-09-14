module Destiny
  class InventoryItemCategory < Base
    belongs_to :inventory_item, primary_key: :bungie_hash, foreign_key: :inventory_item_hash
    belongs_to :category, class_name: "ItemCategory", primary_key: :bungie_hash, foreign_key: :category_hash

    private

    def self.unique_keys
      [ :inventory_item_hash, :category_hash ]
    end
  end
end
