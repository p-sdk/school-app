class PagesController < ApplicationController
  expose(:courses) { current_user.courses }
  expose(:teacher_courses) { current_user.teacher_courses }

  def home
    return unless signed_in?
    render 'dashboard'
  end
end
