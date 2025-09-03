class CreateDestinyPlugSetItems < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_plug_set_items do |t|
      t.bigint :plug_set_hash
      t.bigint :inventory_item_hash
      t.boolean :can_roll
      t.float :weight
      t.float :alternate_weight
    end
  end
end
