module Recordable
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    include Mongoid::Timestamps
  end

  class_methods do
    def upsert_with_timestamps(attributes = {})
      timestamp = DateTime.now

      self.new(attributes.merge(updated_at: timestamp)).upsert(set_on_insert: { created_at: timestamp })
    end
  end
end
