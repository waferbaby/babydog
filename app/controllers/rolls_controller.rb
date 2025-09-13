class RollsController < ApplicationController
  before_action :check_authentication

  def index
    @rolls = fetch
  end

  def fetch
    result = profile_for_current_membership([
      Restiny::ComponentType::CHARACTER_INVENTORIES,
      Restiny::ComponentType::ITEM_STATS
    ]).deep_symbolize_keys

    result.dig(:characterInventories, :data).each do |character_hash, data|
      data[:items].each do |item|
        Destiny::InventoryItemInstance.import_from_payload(item, updates: {
          membership_hash: current_membership.membership_hash,
          character_hash: character_hash
        })
      end
    end
  end
end
