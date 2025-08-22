class CreateDestinySocketTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_socket_types do |t|
      t.bigint :bungie_hash
      t.timestamps
    end
  end
end
