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
    update?
  end

  def list_lectures?
    user_is_course_teacher?(record) || record.studied_by?(user)
  end

  def list_tasks?
    list_lectures?
  end

  def list_students?
    update?
  end

  def enroll?
    !(user.nil? || user_is_course_teacher?(record) || user&.enrolled_in?(record))
  end

  def permitted_attributes
    %i[category_id desc name]
  end
end
