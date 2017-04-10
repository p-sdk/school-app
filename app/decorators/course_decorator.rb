class CourseDecorator < Draper::Decorator
  delegate_all

  def description_formatted
    h.markdown desc
  end

  def points_earned_by(student)
    tasks.map { |task| task.earned_points_by student }.compact.sum
  end

  def total_points
    tasks.map(&:points).sum
  end
end
