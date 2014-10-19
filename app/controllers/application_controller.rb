class ApplicationController < ActionController::Base
  def self.ssl_options
    options = {if: :ssl_configured?}
    options[:host] = ENV['CANONICAL_HOST'] if ENV['CANONICAL_HOST']
    options
  end
  force_ssl ssl_options

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def ssl_configured?
    !Rails.env.development?
  end

end
