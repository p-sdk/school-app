class SolutionDecorator < Draper::Decorator
  delegate_all

  def content_formatted
    h.markdown content
  end

  def earned_points_formatted
    return 'Rozwiązanie czeka na sprawdzenie' unless graded?
    "#{earned_points} / #{task.points}"
  end
end
