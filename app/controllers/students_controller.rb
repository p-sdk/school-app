class StudentsController < ApplicationController
  expose(:course)
  expose(:students) { policy_scope course.students }

  before_action :authenticate_user!

  def index
    authorize course, :list_students?
  end

  def create
    authorize course, :enroll?
    current_user.enroll_in course
    redirect_to course
  end
end
