module Destiny
  class InventoryVaultItem < ManifestEntry
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
      [ :membership_id, :inventory_item_hash ]
    end
  end
end
