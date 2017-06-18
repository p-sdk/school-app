class CoursePolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user_is_teacher?
  end

  def update?
    user_is_teacher? && record.teacher == user
  end

  def destroy?
    update?
  end
end
