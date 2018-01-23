class TasksController < ApplicationController
  expose_decorated(:course)
  expose_decorated(:task, parent: :course)
  expose(:solution) { task.solution_by(current_user) || Solution.new(task: task) }

  before_action :authorize_task

  def create
    if task.save
      flash[:success] = t '.success'
      redirect_to [course, task]
    else
      render :new
    end
  end

  def update
    if task.update(task_params)
      flash[:success] = t '.success'
      redirect_to [course, task]
    else
      render :edit
    end
  end

  def destroy
    task.destroy
    flash[:success] = t '.success'
    redirect_to course
  end

  private

  def task_params
    permitted_attributes(Task)
  end

  def authorize_task
    authorize task
  end
end
