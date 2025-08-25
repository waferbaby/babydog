require_relative './destiny/migration'

class CreateDestinyDamageTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_damage_types do |t|
      Destiny::Migration.add_common_fields(t)
    end
  end
end
