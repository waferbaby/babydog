module Destiny
  class Membership < ManifestEntry
    has_many :item_instances, class_name: "InventoryItemInstance", primary_key: :membership_hash, foreign_key: :membership_hash
    has_many :characters, primary_key: :membership_hash, foreign_key: :membership_hash

    def self.unique_keys
      :membership_hash
    end

    def most_recent_character
      characters.order(:last_played_at).first
    end
  end
end
