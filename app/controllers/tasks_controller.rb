class TasksController < ApplicationController
  expose_decorated(:course)
  expose_decorated(:tasks, from: :course)
  expose_decorated(:task, parent: :course)
  expose(:solution) { task.solution_by current_user }

  before_action :authenticate_user!
  before_action :require_course_user, only: %i(index show)
  before_action :require_course_teacher, only: %i(new edit create update destroy)

  def create
    if task.save
      flash[:success] = 'Zadanie zostało utworzone'
      redirect_to [course, task]
    else
      render :new
    end
  end

  def update
    if task.update(task_params)
      flash[:success] = 'Zadanie zostało zaktualizowane'
      redirect_to [course, task]
    else
      render :edit
    end
  end

  def destroy
    task.destroy
    flash[:success] = 'Zadanie zostało usunięte'
    redirect_to course_tasks_path(course)
  end

  private

  def task_params
    params.require(:task).permit(%i(title desc points))
  end
end
