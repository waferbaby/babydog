require_relative './destiny/migration'

class CreateDestinyItemCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_item_categories do |t|
      Destiny::Migration.add_common_fields(t)

      t.boolean :is_plug, default: false
      t.boolean :is_deprecated, default: false
      t.boolean :is_visible, default: false
    end
  end
end
