class UsersController < ApplicationController
  expose(:users_requesting_upgrade) { User.requesting_upgrade }
  expose(:teachers) { User.teacher }
  expose(:students) { User.student }
  expose_decorated(:user)

  before_action :authenticate_user!, only: :index

  after_action :verify_authorized

  def index
    authorize User
  end

  def show
    authorize user
  end
end
