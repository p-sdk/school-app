class CategoryDecorator < Draper::Decorator
  delegate_all

  def courses_count_formatted
    "( #{courses.count} )"
  end
end
