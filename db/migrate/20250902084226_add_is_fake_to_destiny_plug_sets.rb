class AddIsFakeToDestinyPlugSets < ActiveRecord::Migration[8.0]
  def change
    add_column :destiny_plug_sets, :is_fake, :boolean, default: false
  end
end
