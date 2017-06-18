class TasksController < ApplicationController
  expose_decorated(:course)
  expose_decorated(:tasks) { policy_scope course.tasks }
  expose_decorated(:task, parent: :course)
  expose(:solution) { task.solution_by current_user }
  expose(:current_enrollment) { current_user.enrollments.includes(:solutions).find_by(course: course) }

  before_action :authenticate_user!
  before_action :authorize_task, except: :index

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    authorize course, :list_tasks?
  end

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
    params.require(:task).permit(%i[title desc points])
  end

  def authorize_task
    authorize task
  end
end
