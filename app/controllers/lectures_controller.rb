class LecturesController < ApplicationController
  expose(:course)
  expose(:lectures, ancestor: :course)
  expose_decorated(:lecture, attributes: :lecture_params)

  before_action :authenticate_user!
  before_action :require_course_user, only: %i(index show)
  before_action :require_course_teacher, only: %i(new edit create update destroy)

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
end
