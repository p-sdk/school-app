class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  include SessionsHelper

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def require_teacher
    deny_access unless current_user.teacher?
  end

  def require_course_teacher
    deny_access unless current_user? course.teacher
  end

  def require_course_user
    return if current_user? course.teacher
    return if course.has_student? current_user
    deny_access
  end

  def require_admin
    deny_access unless current_user.admin?
  end

  def deny_access
    flash[:danger] = 'Odmowa dostępu'
    redirect_to root_path
  end

  def not_found
    redirect_to root_path
  end
end
