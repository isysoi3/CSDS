class SessionsController < ApplicationController

  def login
  end

  def attempt_login
    if params[:email].present? && params[:password].present?
      found_user = User.where(email: params[:email]).first
      if found_user and found_user.password == params[:password]
        login_user(found_user)
        redirect_to root_path
      else
        redirect_to root_path
      end
    end
  end

  def logout
  end
end
