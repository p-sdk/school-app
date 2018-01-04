class LecturePolicy < ApplicationPolicy
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

  def permitted_attributes
    %i[attachment content title]
  end
end
