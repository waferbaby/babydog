class CreateDestinyInventoryItemCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_inventory_item_categories, id: false do |t|
      t.bigint :inventory_item_hash
      t.bigint :category_hash
      t.index [ :inventory_item_hash, :category_hash ], unique: true
    end
  end
end
