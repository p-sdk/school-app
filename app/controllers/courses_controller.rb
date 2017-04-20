class CoursesController < ApplicationController
  expose(:courses) { current_user.teacher_courses }
  expose_decorated(:course, attributes: :course_params)

  before_action :authenticate_user!, except: %i(index show)
  before_action :require_teacher, only: %i(new create)

  def index
    self.courses = Course.all
  end

  def show
    self.courses = Course.all
  end

  def create
    if course.save
      flash[:success] = 'Kurs został utworzony'
      redirect_to course
    else
      render :new
    end
  end

  def update
    if course.save
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
