require_relative './destiny/migration'

class CreateDestinyInventoryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_inventory_items do |t|
      Destiny::Migration.add_common_fields(t)

      t.string :flavour_text
      t.integer :guardian_type
      t.integer :tier_type
      t.integer :breaker_type
      t.boolean :is_equippable
      t.boolean :is_featured
      t.boolean :is_holofoil
      t.boolean :is_adept
    end
  end
end
