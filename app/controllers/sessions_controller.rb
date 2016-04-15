class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_path
    else
      flash.now[:danger] = 'Nieprawidłowy email/hasło'
      render :new
    end
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_path
  end
end
