module Destiny
  class Migration
    def self.add_common_fields(table, is_named: true)
      table.bigint :bungie_hash
      table.bigint :index
      table.boolean :is_redacted, default: false
      table.boolean :is_blacklisted, default: false

      if is_named
        table.string :name
        table.string :description
      end

      table.timestamps

      table.index :bungie_hash, unique: true
    end
  end
end
