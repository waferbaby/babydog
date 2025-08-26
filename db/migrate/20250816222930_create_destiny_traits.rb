require_relative './destiny/migration'

class CreateDestinyTraits < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_traits do |t|
      Destiny::Migration.add_common_fields(t)
    end
  end
end
