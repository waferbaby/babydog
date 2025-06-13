class ApplicationController < ActionController::Base
  before_action :check_authentication, except: [ :login ]

  def check_authentication
    session[:destiny_state] ||= SecureRandom.hex(20)

    redirect_to(
      Restiny.get_authorise_url(state: session[:destiny_state]),
      allow_other_host: true) unless session[:destiny_token]
  end

  def login
    session[:destiny_token] = if session[:destiny_state] == params[:state]
                                params[:code]
    else
                                nil
    end

    redirect_to :root
  end
end
