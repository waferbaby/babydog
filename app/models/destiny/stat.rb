module Destiny
  class Stat < Base
    def self.payload_to_attributes(payload)
      super(payload).merge({
        aggregation_type: :aggregationType,
        category: :statCategory
      })
    end
  end
end
