module Destiny
  class InventoryItemInstance < Base
    belongs_to :membership, foreign_key: :membership_hash, primary_key: :membership_hash
    has_one :inventory_item, foreign_key: :bungie_hash, primary_key: :inventory_item_hash

    delegate :bungie_hash, :name, :description, :icon_url, :has_icon?, to: :inventory_item

    def self.payload_to_attributes(payload)
      {
        inventory_item_hash: :itemHash,
        instance_hash: :itemInstanceId,
        inventory_bucket_hash: :bucketHash,
        quantity: :quantity,
        location: :location,
        bind_status: :bindStatus,
        is_lockable: :lockable,
        override_style_hash: :overrideStyleItemHash
      }
    end

    def self.unique_keys
      [ :membership_hash, :inventory_item_hash ]
    end
  end
end
