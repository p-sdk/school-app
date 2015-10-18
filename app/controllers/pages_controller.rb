class PagesController < ApplicationController
  def home
    return unless signed_in?
    @courses = current_user.courses
    @teacher_courses = current_user.teacher_courses if current_user.teacher?
    render 'dashboard'
  end
end
