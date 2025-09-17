require_relative './destiny/migration'

class CreateDestinySeasons < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_seasons do |t|
      Destiny::Migration.add_common_fields(t)
      t.integer :number
      t.boolean :has_icon, default: false
      t.string :icon_url
    end
  end
end
