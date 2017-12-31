class LecturesController < ApplicationController
  expose(:course)
  expose(:lectures) { policy_scope course.lectures }
  expose_decorated(:lecture, parent: :course)

  before_action :authorize_lecture, except: :index

  def index
    authorize course, :list_lectures?
  end

  def create
    if lecture.save
      flash[:success] = t '.success'
      redirect_to [course, lecture]
    else
      render :new
    end
  end

  def update
    if lecture.update(lecture_params)
      flash[:success] = t '.success'
      redirect_to [course, lecture]
    else
      render :edit
    end
  end

  def destroy
    lecture.destroy
    flash[:success] = t '.success'
    redirect_to [course, :lectures]
  end

  private

  def lecture_params
    permitted_attributes(Lecture)
  end

  def authorize_lecture
    authorize lecture
  end
end
