class InventoryItem
  include Recordable

  field :description, type: String

  def self.import(payload)
    self.upsert_with_timestamps(payload)
  end
end
