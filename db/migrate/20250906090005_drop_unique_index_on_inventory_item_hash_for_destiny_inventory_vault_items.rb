class DropUniqueIndexOnInventoryItemHashForDestinyInventoryVaultItems < ActiveRecord::Migration[8.0]
  def change
    remove_index :destiny_inventory_vault_items, :inventory_item_hash
  end
end
