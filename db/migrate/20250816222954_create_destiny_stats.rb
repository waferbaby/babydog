class CreateDestinyStats < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_stats do |t|
      t.bigint :bungie_hash
      t.bigint :index
      t.string :name
      t.string :description
      t.string :icon_url
      t.integer :aggregation_type
      t.integer :category
      t.boolean :has_icon
      t.boolean :is_redacted
      t.boolean :is_blacklisted
      t.timestamps
    end
  end
end
