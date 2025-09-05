class RenameBungieHashInDestinyInventoryVaultItems < ActiveRecord::Migration[8.0]
  def change
    rename_column :destiny_inventory_vault_items, :bungie_hash, :inventory_item_hash
    add_index :destiny_inventory_vault_items, [ :membership_id, :inventory_item_hash ]
  end
end
