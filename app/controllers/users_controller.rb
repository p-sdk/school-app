class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_non_signed_in_user, only: [:new, :create]
  before_action :require_sign_in, only: [:index, :edit, :update, :destroy]
  before_action :require_correct_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:index]

  def index
    @users_requesting_upgrade = User.requesting_upgrade
    @teachers = User.teachers
    @students = User.students
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = 'Twoje konto zostało utworzone'
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Twój profil został zaktualizowany'
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    sign_out
    @user.destroy
    flash[:success] = 'Twoje konto zostało usunięte'
    redirect_to signup_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def require_correct_user
    raise AccessDenied unless current_user? @user
  end
end
