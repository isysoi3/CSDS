class SessionsController < ApplicationController
  before_action :confirm_logged_in, only: [:logout]


  def login
  end

  def attempt_login
    if params[:email].present? && params[:password].present?
      found_user = User.where(email: params[:email]).first
      if found_user
        authenticated_user = found_user.authenticate(params[:password])
        if authenticated_user
          login_user(authenticated_user)
        end
      end
    end
    redirect_to root_path
  end

  def logout
  end
end
