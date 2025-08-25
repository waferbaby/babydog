require_relative './destiny/migration'

class CreateDestinySocketTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_socket_types do |t|
      Destiny::Migration.add_common_fields(t)
    end
  end
end
