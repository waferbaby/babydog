class CreateDestinyInventoryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_inventory_items do |t|
      t.timestamps
    end
  end
end
