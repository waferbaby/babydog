module Destiny
  class PlugSetItem < ManifestEntry
    belongs_to :plug_set, primary_key: :bungie_hash, foreign_key: :plug_set_hash
    belongs_to :inventory_item, primary_key: :bungie_hash, foreign_key: :inventory_item_hash

    private

    def self.unique_keys
      [ :plug_set_hash, :inventory_item_hash ]
    end
  end
end
