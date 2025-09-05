class AddFieldsToDestinyInventoryVaultItems < ActiveRecord::Migration[8.0]
  def change
    add_column :destiny_inventory_vault_items, :state, :integer, default: 0
    add_column :destiny_inventory_vault_items, :bind_status, :integer, default: 0
    add_column :destiny_inventory_vault_items, :transfer_status, :integer, default: 0
    add_column :destiny_inventory_vault_items, :quantity, :integer, default: 0
    add_column :destiny_inventory_vault_items, :is_lockable, :boolean, default: false
    add_column :destiny_inventory_vault_items, :override_style_hash, :bigint
  end
end
