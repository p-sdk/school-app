class CoursesController < ApplicationController
  expose(:courses) { policy_scope Course.all }
  expose_decorated(:course)
  expose(:category) { course.category }
  expose(:lectures) { policy_scope course.lectures }
  expose_decorated(:tasks) { policy_scope course.tasks }
  expose(:student_solutions) { course.solutions.for_student(current_user) }

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :authorize_course

  def create
    course.teacher = current_user
    if course.save
      flash[:success] = t '.success'
      redirect_to course
    else
      render :new
    end
  end

  def update
    if course.update(course_params)
      flash[:success] = t '.success'
      redirect_to course
    else
      render :edit
    end
  end

  def destroy
    course.destroy
    flash[:success] = t '.success'
    redirect_to courses_path
  end

  private

  def course_params
    permitted_attributes(Course)
  end

  def authorize_course
    authorize course
  end
end
