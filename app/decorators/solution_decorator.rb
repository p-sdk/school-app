class SolutionDecorator < Draper::Decorator
  delegate_all

  def content_formatted
    h.markdown content
  end

  def earned_points_formatted
    return I18n.t('decorators.solution.ungraded') unless graded?
    earned_points
  end
end
