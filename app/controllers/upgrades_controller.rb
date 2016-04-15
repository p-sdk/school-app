class UpgradesController < ApplicationController
  before_action :require_sign_in
  before_action :require_admin, only: %i(update destroy)

  expose(:user)

  def create
    current_user.request_upgrade
    flash[:success] = 'Twój wniosek o rozszerzenie uprawnień czeka na akceptację'
    redirect_to current_user
  end

  def update
    user.upgrade
    flash[:success] = 'Uprawnienia użytkownika zostały rozszerzone'
    redirect_to user
  end

  def destroy
    user.downgrade
    flash[:success] = 'Wniosek o rozszerzenie uprawnień został odrzucony'
    redirect_to user
  end
end
