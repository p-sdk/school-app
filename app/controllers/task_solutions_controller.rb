class TaskSolutionsController < ApplicationController
  expose(:course)
  expose(:task, parent: :course)
  expose(:solution, parent: :task)
  expose(:pending_solutions) { solutions.ungraded }
  expose(:graded_solutions) { solutions.graded }

  def index
    authorize task, :list_solutions?
  end

  def create
    authorize solution
    solution.enrollment = current_enrollment
    if solution.save
      flash[:success] = t '.success'
    else
      flash[:danger] = t '.error'
    end
    redirect_to [task.course, task]
  end

  private

  def solution_params
    permitted_attributes(Solution)
  end

  def current_enrollment
    current_user.enrollments.find_by(course: course)
  end

  def solutions
    policy_scope task.solutions.includes(enrollment: :student)
  end
end
