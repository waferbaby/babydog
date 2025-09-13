class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  helper_method :logged_in?, :current_membership, :current_character

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
    member_result = Restiny.get_primary_user_membership(token_result["membership_id"])

    response = Destiny::Membership.upsert(
      membership_hash: member_result["membershipId"],
      membership_type: member_result["membershipType"],
      username: member_result["bungieGlobalDisplayName"]
    )

    session[:bungie_access_token] = token_result["access_token"]
    session[:bungie_membership_id] = response.last["id"]

    result = profile_for_current_membership([
      Restiny::ComponentType::CHARACTERS
    ])

    character_data = result.deep_symbolize_keys.dig(:characters, :data).values
    Destiny::Character.import_collection(character_data)

    redirect_to session[:redirect_to] || :root
  rescue StandardError => e
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

  def current_character
    @current_character ||= current_membership.most_recent_character
  end

  def logged_in?
    session[:bungie_access_token].present? && current_membership.present?
  end

  private

  def profile_for_current_membership(components)
    Restiny.get_profile(
      membership_id: current_membership.membership_hash,
      membership_type: current_membership.membership_type,
      components: components
    )
  end
end
