class CreateDestinyPlugSets < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_plug_sets do |t|
      t.bigint :bungie_hash
      t.bigint :index
      t.string :name
      t.string :description
      t.boolean :has_icon
      t.boolean :is_redacted
      t.boolean :is_blacklisted
      t.timestamps
    end
  end
end
