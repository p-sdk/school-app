class SolutionsController < ApplicationController
  expose_decorated(:solution, build_params: :solution_params_for_create)
  expose_decorated(:task, from: :solution)

  before_action :authenticate_user!
  before_action :authorize_solution, except: :create

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def create
    authorize task, :solve?
    if task.solve content: solution.content, student: current_user
      flash[:success] = 'Rozwiązanie zostało wysłane'
    else
      flash[:danger] = 'Nie udało się wysłać rozwiązania'
    end
    redirect_to [task.course, task]
  end

  def update
    if solution.update(solution_params_for_update)
      flash[:success] = 'Rozwiązanie zostało ocenione'
      redirect_to solution
    else
      render :edit
    end
  end

  def destroy
    solution.destroy
    flash[:success] = 'Rozwiązanie zostało usunięte'
    redirect_to course_task_solutions_path(task.course, task)
  end

  private

  def course
    task.course
  end

  def solution_params_for_create
    params.require(:solution).permit(:task_id, :content)
  end

  def solution_params_for_update
    params.require(:solution).permit(:earned_points)
  end

  def authorize_solution
    authorize solution
  end
end
