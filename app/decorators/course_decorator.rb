class CourseDecorator < Draper::Decorator
  delegate_all

  def description_formatted
    h.markdown desc
  end

  def points_earned_by_enrollment(enrollment)
    enrollment.solutions.map(&:earned_points).compact.sum
  end

  def total_points
    tasks.map(&:points).sum
  end
end
