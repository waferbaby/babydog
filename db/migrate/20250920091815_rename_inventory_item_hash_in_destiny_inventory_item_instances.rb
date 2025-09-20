class RenameInventoryItemHashInDestinyInventoryItemInstances < ActiveRecord::Migration[8.0]
  def change
    rename_column :destiny_inventory_item_instances, :inventory_item_hash, :bungie_hash
  end
end
