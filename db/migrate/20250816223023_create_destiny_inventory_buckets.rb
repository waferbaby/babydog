require_relative './destiny/migration'

class CreateDestinyInventoryBuckets < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_inventory_buckets do |t|
      Destiny::Migration.add_common_fields(t)
    end
  end
end
