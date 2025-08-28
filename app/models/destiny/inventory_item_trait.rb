module Destiny
  class InventoryItemTrait < ApplicationRecord
    belongs_to :inventory_item, primary_key: :bungie_hash, foreign_key: :inventory_item_hash
    belongs_to :trait, primary_key: :bungie_hash, foreign_key: :trait_hash
  end
end
