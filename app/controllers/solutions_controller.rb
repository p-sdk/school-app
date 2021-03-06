class SolutionsController < ApplicationController
  expose_decorated(:solution)
  expose_decorated(:task, from: :solution)

  before_action :authorize_solution

  def update
    if solution.update(solution_params)
      flash[:success] = t '.success'
      redirect_to solution
    else
      render :edit
    end
  end

  def destroy
    solution.destroy
    flash[:success] = t '.success'
    redirect_to [task.course, task, :solutions]
  end

  private

  def solution_params
    permitted_attributes(Solution)
  end

  def authorize_solution
    authorize solution
  end
end
