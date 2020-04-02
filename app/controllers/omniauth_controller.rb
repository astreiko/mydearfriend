class OmniauthController < ApplicationController

    def github
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.from_omniauth(request.env["omniauth.auth"])
        if @user.persisted?
            sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
        else
            flash.notice = 'There was a problem signing you in through Github. Please register or try signing in later.'
            redirect_to new_user_registration_url
        end
    end

    def facebook
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.from_omniauth(request.env["omniauth.auth"])
        if @user.persisted?
            sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
        else
            flash.notice = 'There was a problem signing you in through Facebook. Please register or try signing in later.'
            redirect_to new_user_registration_url
        end
    end

    def google_oauth2
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.from_omniauth(request.env["omniauth.auth"])
        if @user.persisted?
            sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
        else
            flash.notice = 'There was a problem signing you in through Google. Please register or try signing in later.'
            redirect_to new_user_registration_url
        end
    end

  def failure
    flash.notice = 'There was a problem signing you in. Please register or try signing in later.'
    redirect_to root_path
  end

end
