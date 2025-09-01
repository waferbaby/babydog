class VaultController < ApplicationController
  before_action :check_authentication

  def index
    result = Restiny.get_profile(
      membership_id: current_membership.membership_id,
      membership_type: current_membership.membership_type,
      components: [ Restiny::ComponentType::PROFILE_INVENTORIES ]
    )

    result.each do |item|
      pp item
    end
  end
end
