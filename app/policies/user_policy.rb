class UserPolicy < ApplicationPolicy
  def index?
    user_is_admin?
  end
end
