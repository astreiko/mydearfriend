class UsersController < ApplicationController
 # routes to the login / sign up if not authenticated
before_action :authenticate_user!


  def admin
      user = User.find(params[:id])
      if user.admin?
          user.update!(admin: 'false')
        else
          user.update!(admin: 'true')
        end
      redirect_to management_path
  end

  def active
    user = User.find(params[:id])
    if user.active?
       user.update!(active: 'false')
    else
       user.update!(active: 'true')
    end
    if current_user.active?
        redirect_to management_path
    else
        sign_out(current_user)
        redirect_to root_path
    end
  end

  def style
    @user = User.find(params[:user_id])
    if @user.style=="light"
        @user.update(style: "dark")
    else
        @user.update(style: "light")
    end
  end

  def destroy
    if params[:user_id] != nil
        @user = User.find(params[:user_id])
            @user.each do |user|
            user.destroy
        end
        if user_signed_in?
            redirect_to management_path
        else
            redirect_to root_path
        end
    else
        redirect_to management_path
    end
  end


end
