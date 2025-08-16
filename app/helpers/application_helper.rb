module ApplicationHelper
  def current_membership
    @current_membership ||= BungieMembership.find_by(membership_id: session[:bungie_membership_id])
  end

  def logged_in?
    session[:bungie_access_token].present? && current_membership.present?
  end
end
