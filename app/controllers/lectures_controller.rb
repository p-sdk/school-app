class LecturesController < ApplicationController
  expose(:course)
  expose(:lectures, ancestor: :course)
  expose_decorated(:lecture, attributes: :lecture_params)

  before_action :require_sign_in
  before_action :require_correct_user, only: %i(index show)
  before_action :require_correct_teacher, only: %i(new edit create update destroy)

  def create
    if lecture.save
      flash[:success] = 'Wykład został utworzony'
      redirect_to [course, lecture]
    else
      render :new
    end
  end

  def update
    if lecture.save
      flash[:success] = 'Wykład został zaktualizowany'
      redirect_to [course, lecture]
    else
      render :edit
    end
  end

  def destroy
    lecture.destroy
    flash[:success] = 'Wykład został usunięty'
    redirect_to course_lectures_path(course)
  end

  private

  def lecture_params
    params.require(:lecture).permit(%i(title content attachment))
  end

  def require_correct_user
    return if current_user? course.teacher
    return if course.has_student? current_user
    raise AccessDenied
  end

  def require_correct_teacher
    raise AccessDenied unless current_user? course.teacher
  end
end
