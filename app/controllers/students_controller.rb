class StudentsController < ApplicationController
  expose(:course)

  before_action :authenticate_user!
  before_action :require_course_teacher
end
