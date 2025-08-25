require_relative './destiny/migration'

class CreateDestinyInventoryItemStats < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_inventory_item_stats do |t|
      Destiny::Migration.add_common_fields(t)
    end
  end
end
