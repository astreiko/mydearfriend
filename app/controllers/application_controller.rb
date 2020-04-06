class ApplicationController < ActionController::Base
before_action :authenticate_active!
before_action :lang!
before_action :style!

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
    if user_signed_in?
        if current_user.lang == "rus"
            @lang = Lang.all
            @lang2 = "rus"
        else
            @lang = Eng.all
            @lang2 = "eng"
        end
    else
        if Session.find_by(session_id: session.id)
            if Session.find_by(session_id: session.id).lang == "rus"
                @lang = Lang.all
                @lang2 = "rus"
            else
                @lang = Eng.all
                @lang2 = "eng"
            end
        else
            @lang = Eng.all
            @lang2 = "eng"
        end
    end
  end

  def style!
    if user_signed_in?
        if current_user.style == "light"
            @style = "light"
        else
            @style = "dark"
        end
    else
        if Session.find_by(session_id: session.id)
            if Session.find_by(session_id: session.id).style == "light"
                @style = "light"
            else
                @style = "dark"
            end
        else
            @style = "light"
        end
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
