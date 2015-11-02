class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  class NotSignedIn < StandardError; end
  class AccessDenied < StandardError; end

  rescue_from NotSignedIn, with: :not_signed_in
  rescue_from AccessDenied, with: :access_denied
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  expose(:current_user) { User.find_by id: session[:user_id] }

  include SessionsHelper

  private

  def require_sign_in
    raise NotSignedIn unless signed_in?
  end

  def require_non_signed_in_user
    raise AccessDenied if signed_in?
  end

  def require_teacher
    raise AccessDenied unless current_user.teacher?
  end

  def require_admin
    raise AccessDenied unless current_user.admin?
  end

  def not_signed_in
    store_location
    flash[:warning] = 'Strona wymaga logowania.'
    redirect_to signin_path
  end

  def access_denied
    flash[:danger] = 'Odmowa dostępu'
    redirect_to root_path
  end

  def not_found
    redirect_to root_path
  end
end
