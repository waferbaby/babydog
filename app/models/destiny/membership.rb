module Destiny
  class Membership < ManifestEntry
    has_many :vault_items, class_name: "InventoryVaultItem", primary_key: :membership_hash
    has_many :characters, primary_key: :membership_hash, foreign_key: :membership_hash

    def self.unique_keys
      :membership_hash
    end
  end
end
