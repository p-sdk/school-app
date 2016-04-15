class UsersController < ApplicationController
  expose(:users_requesting_upgrade) { User.requesting_upgrade }
  expose(:teachers) { User.teachers }
  expose(:students) { User.students }
  expose(:user, attributes: :user_params)

  before_action :require_non_signed_in_user, only: %i(new create)
  before_action :require_sign_in, only: %i(index edit update destroy)
  before_action :require_correct_user, only: %i(edit update destroy)
  before_action :require_admin, only: :index

  def create
    if user.save
      sign_in user
      flash[:success] = 'Twoje konto zostało utworzone'
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if user.save
      flash[:success] = 'Twój profil został zaktualizowany'
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    sign_out
    user.destroy
    flash[:success] = 'Twoje konto zostało usunięte'
    redirect_to signup_path
  end

  private

  def user_params
    params.require(:user).permit(%i(name email password password_confirmation))
  end

  def require_correct_user
    raise AccessDenied unless current_user? user
  end
end
