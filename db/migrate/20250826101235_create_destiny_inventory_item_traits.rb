require_relative './destiny/migration'
class CreateDestinyInventoryItemTraits < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_inventory_item_traits, id: false do |t|
      t.bigint :inventory_item_hash
      t.bigint :trait_hash
      t.index [ :inventory_item_hash, :trait_hash ], unique: true
    end
  end
end
