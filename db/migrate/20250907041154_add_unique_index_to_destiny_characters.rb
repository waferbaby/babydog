class AddUniqueIndexToDestinyCharacters < ActiveRecord::Migration[8.0]
  def change
    add_index :destiny_characters, [ :character_hash, :membership_hash ], unique: true
  end
end
