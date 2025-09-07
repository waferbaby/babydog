require_relative './destiny/migration'

class CreateDestinyCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_characters do |t|
      t.bigint :character_hash
      t.bigint :membership_hash
      t.bigint :emblem_hash
      t.integer :race
      t.integer :gender
      t.integer :guardian_type
      t.date :last_played_at
      t.timestamps
    end
  end
end
