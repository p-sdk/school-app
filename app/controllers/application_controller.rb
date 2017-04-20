class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  class AccessDenied < StandardError; end

  rescue_from AccessDenied, with: :access_denied
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  include SessionsHelper

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def require_teacher
    raise AccessDenied unless current_user.teacher?
  end

  def require_admin
    raise AccessDenied unless current_user.admin?
  end

  def access_denied
    flash[:danger] = 'Odmowa dostępu'
    redirect_to root_path
  end

  def not_found
    redirect_to root_path
  end
end
