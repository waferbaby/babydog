module Destiny
  class Trait < ManifestEntry
    has_many :inventory_item_traits, foreign_key: :inventory_item_hash
    has_many :inventory_items, through: :inventory_item_traits
  end
end
