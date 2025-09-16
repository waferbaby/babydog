class AddIconsToDestinyInventoryItems < ActiveRecord::Migration[8.0]
  def change
    add_column :destiny_inventory_items, :has_icon, :boolean, default: false
    add_column :destiny_inventory_items, :icon_url, :string
    add_column :destiny_inventory_items, :high_res_icon_url, :string
  end
end
