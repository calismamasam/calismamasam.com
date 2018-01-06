class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :ensure_signup_complete
  after_action :store_location

  def store_location
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def default_url_options(_options = {})
    if Rails.env.production?
      { protocol: 'https' }
    else
      { protocol: 'http' }
    end
  end

  def after_sign_in_path_for(_resource)
    session[:previous_url] || root_path
  end

  def ensure_signup_complete
    return if action_name == 'finish_signup'
    return if controller_name == 'sessions' && action_name == 'destroy'
    redirect_to finish_signup_path(current_user) if current_user && !current_user.email_verified?
  end
end
