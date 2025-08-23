module Destiny
  class Stat < ManifestEntry
    def self.payload_to_attributes(payload)
      super(payload).merge({
        aggregation_type: :aggregationType,
        category: :statCategory
      })
    end
  end
end
