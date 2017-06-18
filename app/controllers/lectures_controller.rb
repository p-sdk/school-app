class LecturesController < ApplicationController
  expose(:course)
  expose(:lectures) { policy_scope course.lectures }
  expose_decorated(:lecture, parent: :course)

  before_action :authenticate_user!
  before_action :authorize_lecture, except: :index

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def create
    if lecture.save
      flash[:success] = 'Wykład został utworzony'
      redirect_to [course, lecture]
    else
      render :new
    end
  end

  def update
    if lecture.update(lecture_params)
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
    params.require(:lecture).permit(%i[title content attachment])
  end

  def authorize_lecture
    authorize lecture
  end
end
