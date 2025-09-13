class RenameDestinyInventoryVaultItemsToDestinyInventoryItemInstances < ActiveRecord::Migration[8.0]
  def change
    rename_table :destiny_inventory_vault_items, :destiny_inventory_item_instances
  end
end
