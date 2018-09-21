class CourseDecorator < Draper::Decorator
  delegate_all

  def description_formatted
    h.markdown desc
  end

  def points_earned_by_enrollment(enrollment)
    enrollment.solutions.sum(:earned_points)
  end

  def total_points
    tasks.sum(:points)
  end
end
