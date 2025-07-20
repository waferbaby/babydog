class ApplicationController < ActionController::Base
  def login
    unless session[:destiny_token].present?
      if params[:code].present?
        token_response = Restiny.request_access_token(params[:code])
        raise "No access token in response" unless token_response["access_token"].present?

        membership_response = Restiny.get_primary_user_membership(token_response["membership_id"])
        raise "No membership details" unless membership_response.present?

        session[:destiny_token] = token_response["access_token"]

        Membership.upsert_with_timestamps(
          id: membership_response["membershipId"],
          type: membership_response["membershipType"],
          display_name: membership_response["displayName"]
        )

        session[:destiny_membership_id] = membership_response["membershipId"]
      end
    end

    redirect_to session[:redirect_url] || :root
  rescue StandardError => e
    Rails.logger.error("Failed to log in: #{e}")

    logout
  end

  def logout
    reset_session
    redirect_to :root
  end

  private

  def check_authentication
    session[:auth_state] ||= SecureRandom.hex(20)

    unless session[:destiny_token].present?
      session[:redirect_url] = request.path
      redirect_to(Restiny.get_authorise_url(state: session[:auth_state]), allow_other_host: true)
    end
  end
end
