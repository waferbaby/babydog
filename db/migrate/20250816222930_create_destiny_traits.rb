class CreateDestinyTraits < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_traits do |t|
      t.bigint :bungie_hash
      t.timestamps
    end
  end
end
