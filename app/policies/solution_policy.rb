class SolutionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user&.teacher?
        scope.where(task: user.teacher_courses.includes(:tasks).flat_map(&:task_ids))
      else
        scope.where(enrollment: user&.enrollments)
      end
    end
  end

  def create?
    Pundit.policy!(user, record.task).solve?
  end

  def update?
    user_is_course_teacher?(record.task.course)
  end

  def destroy?
    user_is_course_teacher?(record.task.course)
  end
end
