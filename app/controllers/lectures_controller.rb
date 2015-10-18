class LecturesController < ApplicationController
  before_action :set_course
  before_action :set_lecture, only: [:show, :edit, :update, :destroy]
  before_action :require_sign_in
  before_action :require_correct_user, only: [:index, :show]
  before_action :require_correct_teacher, only: [:new, :edit, :create, :update, :destroy]

  def index
    @lectures = @course.lectures
  end

  def show
  end

  def new
    @lecture = @course.lectures.build
  end

  def edit
  end

  def create
    @lecture = @course.lectures.build(lecture_params)
    if @lecture.save
      flash[:success] = 'Wykład został utworzony'
      redirect_to [@course, @lecture]
    else
      render :new
    end
  end

  def update
    if @lecture.update(lecture_params)
      flash[:success] = 'Wykład został zaktualizowany'
      redirect_to [@course, @lecture]
    else
      render :edit
    end
  end

  def destroy
    @lecture.destroy
    flash[:success] = 'Wykład został usunięty'
    redirect_to course_lectures_path(@course)
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_lecture
    @lecture = @course.lectures.find(params[:id])
  end

  def lecture_params
    params.require(:lecture).permit(:title, :content, :attachment)
  end

  def require_correct_user
    return if current_user? @course.teacher
    return if @course.has_student? current_user
    raise AccessDenied
  end

  def require_correct_teacher
    raise AccessDenied unless current_user? @course.teacher
  end
end
