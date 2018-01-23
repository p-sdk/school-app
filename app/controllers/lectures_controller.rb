class LecturesController < ApplicationController
  expose(:course)
  expose_decorated(:lecture, parent: :course)

  before_action :authorize_lecture

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
    redirect_to course
  end

  private

  def lecture_params
    permitted_attributes(Lecture)
  end

  def authorize_lecture
    authorize lecture
  end
end
