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

  def status_badge_for(user, solutions)
    return if course.teacher == user

    status_badge(status(solutions))
  end

  private

  def status(solutions)
    solution = solutions.detect { |s| s.task_id == id }
    return :unsolved unless solution
    return :graded if solution.graded?

    :ungraded
  end

  def status_badge(type)
    h.content_tag 'span', class: ['task-status-badge', type] do
      I18n.t("decorators.task.#{type}")
    end
  end
end
