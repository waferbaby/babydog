class CreateDestinyInventoryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_inventory_items do |t|
      t.bigint :bungie_hash
      t.string :name
      t.string :description
      t.string :flavour_text
      t.integer :tier_type
      t.boolean :is_featured
      t.boolean :is_holofoil
      t.boolean :is_adept
      t.timestamps
    end
  end
end
