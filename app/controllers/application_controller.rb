class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  helper_method :logged_in?, :current_membership

  def check_authentication
    return if logged_in?

    session[:redirect_to] = request.original_fullpath
    session[:bungie_state] = SecureRandom.hex(10)

    redirect_to(
      Restiny.get_authorise_url(redirect_url: url_for(:login), state: session[:bungie_state]),
      allow_other_host: true
    )
  end

  def login
    unless params[:state] == session[:bungie_state]
      flash.alert = "Please check your credentials and try again"
      redirect_to :root and return
    end

    token_result = Restiny.request_access_token(params[:code])
    member_result = Restiny.get_primary_user_membership(token_result['membership_id'])

    membership = Destiny::Membership.find_or_initialize_by(membership_id: member_result['membershipId'])
    membership.update!(
      membership_type: member_result['membershipType'],
      username: member_result['bungieGlobalDisplayName']
    )

    session[:bungie_access_token] = token_result['access_token']
    session[:bungie_membership_id] = membership.id

    redirect_to session[:redirect_to] || :root
  rescue Restiny::AuthenticationError => e
    Rails.logger.error("Failed to authenticate user: #{e}")
    flash.alert = "Login failed - please try again"

    redirect_to :root
  end

  def logout
    reset_session
    redirect_to :root
  end

  def current_membership
    @current_membership ||= Destiny::Membership.find_by(id: session[:bungie_membership_id])
  end

  def logged_in?
    session[:bungie_access_token].present? && current_membership.present?
  end
end
