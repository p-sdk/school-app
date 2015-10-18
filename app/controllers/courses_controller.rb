class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :students]
  before_action :require_sign_in, except: [:index, :show]
  before_action :require_teacher, only: [:new, :create]
  before_action :require_correct_teacher, only: [:edit, :update, :destroy, :students]

  def index
    @courses = Course.all
  end

  def new
    @course = current_user.teacher_courses.build
  end

  def create
    @course = current_user.teacher_courses.build(course_params)
    if @course.save
      flash[:success] = 'Kurs został utworzony'
      redirect_to @course
    else
      render :new
    end
  end

  def update
    if @course.update(course_params)
      flash[:success] = 'Kurs został zaktualizowany'
      redirect_to @course
    else
      render :edit
    end
  end

  def destroy
    @course.destroy
    flash[:success] = 'Kurs został usunięty'
    redirect_to courses_path
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, :desc, :category_id)
  end

  def require_correct_teacher
    raise AccessDenied unless current_user? @course.teacher
  end
end
