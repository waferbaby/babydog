require_relative './destiny/migration'

class CreateDestinyStats < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_stats do |t|
      Destiny::Migration.add_common_fields(t)

      t.integer :aggregation_type
      t.integer :category
    end
  end
end
