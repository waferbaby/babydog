module Destiny
  class Membership < ApplicationRecord
    has_many :vault_items, class_name: "InventoryVaultItem", primary_key: :membership_id
  end
end
