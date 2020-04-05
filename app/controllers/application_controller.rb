class ApplicationController < ActionController::Base
before_action :authenticate_active!
before_action :lang!

  def authenticate_active!
    if user_signed_in?
        unless current_user.active
            flash.notice = 'Sorry, your account is blocked!'
            sign_out(current_user)
            user_session_path
        end
    end
  end

  def lang!
    if user_signed_in? && current_user.lang == "rus"
      @lang = Lang.all
    else
      @lang = Eng.all
    end
  end

  def after_sign_in_path_for(resource)
      if current_user.active?
        if current_user.admin?
            management_path
        else
            user_root_path(:id => current_user)
        end
      else
        flash.notice = 'Sorry, your account is blocked!'
        sign_out(current_user)
        user_session_path
      end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  # allow changing fields name, active and admin in the table User
  before_action :configure_permitted_parameters, if:  :devise_controller?
  protected
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:sign_up, keys: [:active])
      devise_parameter_sanitizer.permit(:sign_up, keys: [:admin])
  end



end
