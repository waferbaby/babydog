class CreateDestinyInventoryBuckets < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_inventory_buckets do |t|
      t.bigint :bungie_hash
      t.timestamps
    end
  end
end
