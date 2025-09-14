module Destiny
  class PlugSet < Base
    def self.payload_to_attributes(payload)
      super(payload).merge({
        is_fake: :isFakePlugSet
      })
    end

    def self.link_associations(payload)
      if payload.key?(:reusablePlugItems)
        Destiny::PlugSetItem.where(plug_set_hash: payload[:hash]).delete_all

        payload[:reusablePlugItems].each do |plug_item|
          Destiny::PlugSetItem.import_from_payload(plug_item, updates: { plug_set_hash: payload[:hash] })
        end
      end
    end
  end
end
