class AddCharacterHashToDestinyInventoryItemInstances < ActiveRecord::Migration[8.0]
  def change
    add_column :destiny_inventory_item_instances, :character_hash, :bigint
  end
end
