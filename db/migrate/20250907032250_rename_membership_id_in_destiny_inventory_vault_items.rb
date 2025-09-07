class RenameMembershipIdInDestinyInventoryVaultItems < ActiveRecord::Migration[8.0]
  def change
    rename_column :destiny_inventory_vault_items, :membership_id, :membership_hash
  end
end
