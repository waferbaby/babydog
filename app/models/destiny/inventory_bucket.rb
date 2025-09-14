module Destiny
  class InventoryBucket < Base
    has_many :inventory_items, foreign_key: :inventory_bucket_hash, primary_key: :bungie_hash
  end
end
