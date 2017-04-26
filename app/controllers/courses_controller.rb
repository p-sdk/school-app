class CoursesController < ApplicationController
  expose(:courses) { Course.all }
  expose_decorated(:course)

  before_action :authenticate_user!, except: %i(index show)
  before_action :require_teacher, only: %i(new create)
  before_action :require_course_teacher, only: %i(edit update destroy students)

  def create
    course.teacher = current_user
    if course.save
      flash[:success] = 'Kurs został utworzony'
      redirect_to course
    else
      render :new
    end
  end

  def update
    if course.update(course_params)
      flash[:success] = 'Kurs został zaktualizowany'
      redirect_to course
    else
      render :edit
    end
  end

  def destroy
    course.destroy
    flash[:success] = 'Kurs został usunięty'
    redirect_to courses_path
  end

  private

  def course_params
    params.require(:course).permit(%i(name desc category_id))
  end
end
