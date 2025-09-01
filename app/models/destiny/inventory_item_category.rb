module Destiny
  class InventoryItemCategory < ApplicationRecord
    belongs_to :inventory_item, primary_key: :bungie_hash, foreign_key: :inventory_item_hash
    belongs_to :category, primary_key: :bungie_hash, foreign_key: :category_hash
  end
end
