class CreateDestinyItemCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_item_categories do |t|
      t.bigint :bungie_hash
      t.string :name
      t.string :description
      t.integer :item_type
      t.integer :item_sub_type
      t.integer :guardian_type
      t.boolean :is_plug
      t.timestamps
    end
  end
end
