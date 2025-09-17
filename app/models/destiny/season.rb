module Destiny
  class Season < Base
    def self.payload_to_attributes(payload)
      super(payload).merge({
        number: :seasonNumber,
        has_icon: [ :displayProperties, :hasIcon ],
        icon_url: [ :displayProperties, :icon ]
      })
    end
  end
end
