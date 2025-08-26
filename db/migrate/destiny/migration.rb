module Destiny
  class Migration
    def self.add_common_fields(table)
      table.bigint :bungie_hash
      table.bigint :index
      table.string :name
      table.string :description
      table.boolean :is_redacted, default: false
      table.boolean :is_blacklisted, default: false
      table.timestamps

      table.index :bungie_hash, unique: true
    end
  end
end
