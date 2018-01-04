class CategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user_is_admin?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    %i[name]
  end
end
