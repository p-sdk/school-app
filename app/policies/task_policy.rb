class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user&.teacher?
        scope.where(course: user.teacher_courses + user.courses)
      else
        scope.where(course: user&.courses)
      end
    end
  end

  def create?
    user_is_course_teacher?(record.course)
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def list_solutions?
    create?
  end

  def permitted_attributes
    %i[desc points title]
  end
end
