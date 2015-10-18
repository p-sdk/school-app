class UpgradesController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :require_sign_in
  before_action :require_admin, only: [:update, :destroy]

  def create
    current_user.request_upgrade
    flash[:success] = 'Twój wniosek o rozszerzenie uprawnień czeka na akceptację'
    redirect_to current_user
  end

  def update
    @user.upgrade
    flash[:success] = 'Uprawnienia użytkownika zostały rozszerzone'
    redirect_to @user
  end

  def destroy
    @user.downgrade
    flash[:success] = 'Wniosek o rozszerzenie uprawnień został odrzucony'
    redirect_to @user
  end

  def set_user
    @user = User.find(params[:id])
  end
end
