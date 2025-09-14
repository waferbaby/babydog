module Destiny
  class InventoryItemTrait < Base
    belongs_to :inventory_item, primary_key: :bungie_hash, foreign_key: :inventory_item_hash
    belongs_to :trait, primary_key: :bungie_hash, foreign_key: :trait_hash

    private

    def self.unique_keys
      [ :inventory_item_hash, :trait_hash ]
    end
  end
end
