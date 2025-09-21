class RemoveIndexOnDestinyInventoryItemInstances < ActiveRecord::Migration[8.0]
  def change
    remove_index :destiny_inventory_item_instances, [ :membership_hash, :bungie_hash ]
  end
end
