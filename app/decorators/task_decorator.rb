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

  def status_for(student)
    return 'nierozwiązane' unless solved_by? student
    return 'ocenione' if graded_for? student
    'czeka na sprawdzenie'
  end
end
