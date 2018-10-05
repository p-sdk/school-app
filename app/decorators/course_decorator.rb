class CourseDecorator < Draper::Decorator
  delegate_all

  def description_formatted
    h.markdown desc
  end

  def points_earned_by_student(student)
    solutions.for_student(student).sum(:earned_points)
  end

  def score_for(student)
    "#{points_earned_by_student(student)} / #{total_points}"
  end

  def total_points
    tasks.sum(:points)
  end
end
