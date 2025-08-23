class CreateDestinyInventoryItemStats < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_inventory_item_stats do |t|
      t.timestamps
    end
  end
end
