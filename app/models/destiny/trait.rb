module Destiny
  class Trait < Base
    has_many :inventory_item_traits, foreign_key: :trait_hash, primary_key: :bungie_hash
    has_many :inventory_items, through: :inventory_item_traits

    def self.payload_to_attributes(payload)
      super(payload).merge({
        has_icon: [ :displayProperties, :hasIcon ],
        icon_url: [ :displayProperties, :icon ],
      })
    end
  end
end
