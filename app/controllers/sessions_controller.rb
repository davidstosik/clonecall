class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    if user = User.find_by_provider_and_uid(auth['provider'], auth['uid'])
      user.update_with_auth auth
    else
      user = User.create_with_omniauth(auth)
    end
    session[:user_id] = user.id
    redirect_to dashboard_path, notice: 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed out!'
  end

end
