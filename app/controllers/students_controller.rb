class StudentsController < ApplicationController
  expose(:course)

  before_action :authenticate_user!
  before_action :require_course_teacher, only: :index

  def create
    current_user.enroll_in course
    redirect_to course
  end
end
