class TaskSolutionsController < ApplicationController
  expose(:course)
  expose(:task, parent: :course)
  expose(:pending_solutions) { task.solutions.ungraded }
  expose(:graded_solutions) { task.solutions.graded }

  before_action :authenticate_user!
  before_action :require_course_teacher, only: :index
end
