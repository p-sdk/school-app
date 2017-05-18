class UpgradesController < ApplicationController
  expose(:user)

  before_action :authenticate_user!
  before_action :authorize_user, only: %i[update destroy]

  after_action :verify_authorized

  def create
    skip_authorization
    current_user.request_upgrade
    flash[:success] = 'Twój wniosek o rozszerzenie uprawnień czeka na akceptację'
    redirect_to current_user
  end

  def update
    user.approve_upgrade_request
    flash[:success] = 'Uprawnienia użytkownika zostały rozszerzone'
    redirect_to user
  end

  def destroy
    user.reject_upgrade_request
    flash[:success] = 'Wniosek o rozszerzenie uprawnień został odrzucony'
    redirect_to user
  end

  private

  def authorize_user
    authorize user, :update?
  end
end
