class CoursePolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user_is_teacher?
  end

  def update?
    user_is_course_teacher?(record)
  end

  def destroy?
    user_is_course_teacher?(record)
  end
end
