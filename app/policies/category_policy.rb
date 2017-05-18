class CategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user_is_admin?
  end

  def update?
    user_is_admin?
  end

  def destroy?
    user_is_admin?
  end
end
