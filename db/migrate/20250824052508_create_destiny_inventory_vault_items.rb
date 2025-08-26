class CreateDestinyInventoryVaultItems < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_inventory_vault_items do |t|
      t.bigint :bungie_hash
      t.bigint :instance_hash
      t.bigint :location
      t.belongs_to :membership
      t.belongs_to :inventory_bucket
      t.timestamps

      t.index :bungie_hash, unique: true
      t.index :instance_hash, unique: true
    end
  end
end
