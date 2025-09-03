class AddUniqueIndexToDestinyPlugSetItems < ActiveRecord::Migration[8.0]
  def change
    add_index :destiny_plug_set_items, [ :plug_set_hash, :inventory_item_hash ], unique: true
  end
end
