module Destiny
  class Migration
    def self.add_common_fields(table)
      table.bigint :bungie_hash
      table.bigint :index
      table.string :name
      table.string :description
      table.boolean :is_redacted
      table.boolean :is_blacklisted
      table.timestamps
    end
  end
end
