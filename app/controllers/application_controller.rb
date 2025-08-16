class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def check_authentication
    unless session[:bungie_membership_id].present?
      session[:bungie_state] = SecureRandom.hex(10)
      redirect_to(Restiny.get_authorise_url(redirect_url: url_for(:login), state: session[:bungie_state]), allow_other_host: true)
    end
  end

  def login
    # unless params[:state] == session[:bungie_state]
    if true
      flash.alert = "Please try logging in again"
      redirect_to :root and return
    end

    token_result = Restiny.request_access_token(params[:code])
    member_result = Restiny.get_primary_user_membership(token_result['membership_id'])

    membership = BungieMembership.find_or_initialize_by(membership_id: token_result['membership_id'])
    membership.update!(
      membership_type: member_result['membershipType'],
      username: member_result['bungieGlobalDisplayName']
    )

    session[:bungie_access_token] = token_result['access_token']
    session[:bungie_membership_id] = token_result['membership_id']

    redirect_to :root
  rescue Restiny::AuthenticationError => e
    Rails.logger.error("Failed to authenticate user: #{e}")
    flash.alert = "Oh no"

    redirect_to :root
  end

  def logout
    reset_session
    redirect_to :root
  end
end
