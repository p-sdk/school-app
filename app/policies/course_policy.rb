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

  def list_lectures?
    user_is_course_teacher?(record) || record.has_student?(user)
  end

  def list_tasks?
    user_is_course_teacher?(record) || record.has_student?(user)
  end
end
