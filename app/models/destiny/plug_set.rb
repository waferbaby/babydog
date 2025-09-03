module Destiny
  class PlugSet < ManifestEntry
    def self.payload_to_attributes(payload)
      super(payload).merge({
        is_fake: :isFakePlugSet
      })
    end

    def self.link_associations(payload)
      if payload.key?(:reusablePlugItems)
        Destiny::PlugSetItem.where(plug_set_hash: payload[:hash]).delete_all

        payload[:reusablePlugItems].each do |plug_item|
          Destiny::PlugSetItem.import_entry(
            plug_set_hash: payload[:hash],
            inventory_item_hash: plug_item[:plugItemHash],
            can_roll: plug_item[:currentlyCanRoll],
            weight: plug_item[:weight],
            alternate_weight: plug_item[:alternateWeight]
          )
        end
      end
    end
  end
end
