class EnrollmentsController < ApplicationController
  before_action :authenticate_user!

  def create
    course = Course.find(params[:enrollment][:course_id])
    current_user.enroll_in course
    redirect_to course
  end
end
