class ChangeLastPlayedAtColumnTypeForDestinyCharacters < ActiveRecord::Migration[8.0]
  def change
    change_column :destiny_characters, :last_played_at, :datetime
  end
end
