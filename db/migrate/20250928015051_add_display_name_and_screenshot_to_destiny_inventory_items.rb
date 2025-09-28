class AddDisplayNameAndScreenshotToDestinyInventoryItems < ActiveRecord::Migration[8.0]
  def change
    add_column :destiny_inventory_items, :display_name, :string
    add_column :destiny_inventory_items, :screenshot_url, :string
  end
end
