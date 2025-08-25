require_relative './destiny/migration'

class CreateDestinyPlugSets < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_plug_sets do |t|
      Destiny::Migration.add_common_fields(t)
    end
  end
end
