class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include Pundit

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :deny_access

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def deny_access
    flash[:danger] = 'Odmowa dostępu'
    redirect_to root_path
  end
end
