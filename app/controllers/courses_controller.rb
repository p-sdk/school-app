class CoursesController < ApplicationController
  expose(:courses) { policy_scope Course.all }
  expose_decorated(:course)

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
    params.require(:course).permit(%i[name desc category_id])
  end

  def authorize_course
    authorize course
  end
end
