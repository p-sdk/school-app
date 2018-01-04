class UpgradePolicy < ApplicationPolicy
  def create?
    !user.nil?
  end

  def update?
    user_is_admin?
  end

  def destroy?
    update?
  end
end
