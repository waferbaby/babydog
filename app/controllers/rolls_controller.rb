class RollsController < ApplicationController
  before_action :check_authentication

  def index
    fetch

    @rolls = current_membership.item_instances
  end

  def fetch
    result = profile_for_current_membership([
      Restiny::ComponentType::CHARACTER_INVENTORIES,
      Restiny::ComponentType::PROFILE_INVENTORIES,
      Restiny::ComponentType::ITEM_STATS
    ]).deep_symbolize_keys

    items = result.dig(:profileInventory, :data, :items)
    unless items.blank?
      Destiny::InventoryItemInstance.import_collection(items, updates: {
        membership_hash: current_membership.membership_hash
      })
    end

    result.dig(:characterInventories, :data)&.each do |character_hash, data|
      data[:items].each do |item|
        Destiny::InventoryItemInstance.import_from_payload(item, updates: {
          membership_hash: current_membership.membership_hash,
          character_hash: character_hash
        })
      end
    end
  end
end
