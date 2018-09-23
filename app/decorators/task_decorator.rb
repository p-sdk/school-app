class TaskDecorator < Draper::Decorator
  delegate_all

  def average_score
    graded_solutions = solutions.graded
    return '---' if graded_solutions.empty?
    graded_solutions.average(:earned_points).round(1)
  end

  def description_formatted
    h.markdown desc
  end

  def status_for(user, solutions)
    return if course.teacher == user
    solution = solutions.detect { |s| s.task_id == id }
    return status_badge(:unsolved) unless solution
    return status_badge(:graded) if solution.graded?
    status_badge(:ungraded)
  end

  private

  def status_badge(type)
    h.content_tag 'span', class: ['task-status', type] do
      I18n.t("decorators.task.#{type}")
    end
  end
end
