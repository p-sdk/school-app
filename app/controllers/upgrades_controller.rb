class UpgradesController < ApplicationController
  expose(:user)

  before_action :authorize_upgrade

  def create
    current_user.request_upgrade
    flash[:success] = t '.success'
    redirect_to current_user
  end

  def update
    user.approve_upgrade_request
    flash[:success] = t '.success'
    redirect_to user
  end

  def destroy
    user.reject_upgrade_request
    flash[:success] = t '.success'
    redirect_to user
  end

  private

  def authorize_upgrade
    authorize :upgrade
  end
end
