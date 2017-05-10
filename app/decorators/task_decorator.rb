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

  def status_for(user)
    return if task.course.teacher == user
    return 'nierozwiązane' unless solved_by? user
    return 'ocenione' if graded_for? user
    'czeka na sprawdzenie'
  end
end
