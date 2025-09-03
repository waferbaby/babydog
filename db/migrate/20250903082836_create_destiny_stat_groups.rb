class CreateDestinyStatGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_stat_groups do |t|
      t.bigint :bungie_hash
      t.index :bungie_hash, unique: true
    end
  end
end
