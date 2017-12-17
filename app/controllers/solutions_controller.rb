class SolutionsController < ApplicationController
  expose_decorated(:solution, build_params: :solution_params_for_create)
  expose_decorated(:task, from: :solution)

  before_action :authorize_solution

  def create
    solution.enrollment = current_enrollment
    if solution.save
      flash[:success] = t '.success'
    else
      flash[:danger] = t '.error'
    end
    redirect_to [task.course, task]
  end

  def update
    if solution.update(solution_params_for_update)
      flash[:success] = t '.success'
      redirect_to solution
    else
      render :edit
    end
  end

  def destroy
    solution.destroy
    flash[:success] = t '.success'
    redirect_to course_task_solutions_path(task.course, task)
  end

  private

  def course
    task.course
  end

  def current_enrollment
    current_user.enrollments.find_by(course: course)
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
