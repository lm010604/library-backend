class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id]) if
      session[:current_user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    redirect_to new_session_path, alert: "Please sign in first." unless logged_in?
  end
end
