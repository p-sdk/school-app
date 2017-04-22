class TasksController < ApplicationController
  expose_decorated(:course)
  expose_decorated(:tasks, ancestor: :course)
  expose_decorated(:task, attributes: :task_params)
  expose(:solution) { task.solution_by current_user }
  expose(:pending_solutions) { task.solutions.ungraded }
  expose(:graded_solutions) { task.solutions.graded }

  before_action :authenticate_user!
  before_action :require_course_user, only: %i(index show)
  before_action :require_course_teacher, only: %i(new edit create update destroy solutions)

  def create
    if task.save
      flash[:success] = 'Zadanie zostało utworzone'
      redirect_to [course, task]
    else
      render :new
    end
  end

  def update
    if task.save
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
