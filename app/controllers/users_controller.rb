class UsersController < ApplicationController
  expose(:users_requesting_upgrade) { User.requesting_upgrade }
  expose(:teachers) { User.teachers }
  expose(:students) { User.students }
  expose_decorated(:user)

  before_action :authenticate_user!, only: :index
  before_action :require_admin, only: :index
end
