class AddIconsToDestinyTraits < ActiveRecord::Migration[8.0]
  def change
    add_column :destiny_traits, :has_icon, :boolean, default: false
    add_column :destiny_traits, :icon_url, :string
  end
end
