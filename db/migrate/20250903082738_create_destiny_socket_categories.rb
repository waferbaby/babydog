class CreateDestinySocketCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_socket_categories do |t|
      t.timestamps
    end
  end
end
