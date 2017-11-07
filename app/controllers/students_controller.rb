class StudentsController < ApplicationController
  expose(:course)
  expose(:students) { policy_scope course.students }

  before_action :authenticate_user!

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    authorize course, :list_students?
  end

  def create
    authorize course, :enroll?
    current_user.enroll_in course
    redirect_to course
  end
end
