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
    return 'nierozwiązane' unless solution
    return 'ocenione' if solution.graded?
    'czeka na sprawdzenie'
  end
end
