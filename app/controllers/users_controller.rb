class UsersController < ApplicationController
  expose(:users_requesting_upgrade) { User.requesting_upgrade }
  expose(:teachers) { User.teacher }
  expose(:students) { User.student }
  expose_decorated(:user)

  skip_before_action :authenticate_user!, only: :show
  before_action :authorize_user
  before_action :skip_policy_scope, only: :index

  private

  def authorize_user
    authorize user
  end
end
