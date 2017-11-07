class TaskSolutionsController < ApplicationController
  expose(:course)
  expose(:task, parent: :course)
  expose(:pending_solutions) { task.solutions.ungraded }
  expose(:graded_solutions) { task.solutions.graded }

  before_action :authenticate_user!

  def index
    authorize task, :list_solutions?
  end
end
