class TaskSolutionsController < ApplicationController
  expose(:course)
  expose(:task, parent: :course)
  expose(:pending_solutions) { solutions.ungraded }
  expose(:graded_solutions) { solutions.graded }

  before_action :authenticate_user!

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    authorize task, :list_solutions?
  end

  private

  def solutions
    policy_scope task.solutions.includes(enrollment: :student)
  end
end
