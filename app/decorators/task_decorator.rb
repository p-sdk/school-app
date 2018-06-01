class TaskDecorator < Draper::Decorator
  delegate_all

  def average_score
    graded_points = solutions.graded.map(&:earned_points)
    return '---' if graded_points.empty?
    graded_points.sum / graded_points.size
  end

  def description_formatted
    h.markdown desc
  end

  def status_for_enrollment(enrollment)
    return unless enrollment
    solution = enrollment.solutions.detect { |s| s.task_id == id }
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
