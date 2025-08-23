class CreateDestinyInventoryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_inventory_items do |t|
      t.bigint :bungie_hash
      t.bigint :index
      t.string :name
      t.string :description
      t.string :flavour_text
      t.integer :item_type
      t.integer :item_subtype
      t.integer :guardian_type
      t.integer :tier_type
      t.integer :breaker_type
      t.boolean :is_equippable
      t.boolean :is_featured
      t.boolean :is_holofoil
      t.boolean :is_adept
      t.boolean :is_redacted
      t.boolean :is_blacklisted
      t.timestamps
    end
  end
end
