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
    task = record.task
    task.course.has_student?(user) && !task.solved_by?(user)
  end

  def update?
    user_is_course_teacher?(record.task.course)
  end

  def destroy?
    update?
  end

  def permitted_attributes
    if user_is_teacher?
      %i[earned_points]
    else
      %i[content task_id]
    end
  end
end
