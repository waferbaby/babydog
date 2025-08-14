class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def check_authentication
    unless session[:bungie_account].present?
      session[:bungie_state] = SecureRandom.hex(10)
      redirect_to(Restiny.get_authorise_url(redirect_url: url_for(:login), state: session[:bungie_state]), allow_other_host: true)
    end
  end
end
