class SolutionsController < ApplicationController
  expose_decorated(:solution)
  expose_decorated(:task, from: :solution)

  before_action :set_create_params, only: :create
  before_action :authenticate_user!
  before_action :require_correct_user, only: :show
  before_action :require_course_teacher, only: %i[edit update destroy]
  before_action :require_correct_student, only: :create

  def create
    if @task.solve content: @content, student: current_user
      flash[:success] = 'Rozwiązanie zostało wysłane'
    else
      flash[:danger] = 'Nie udało się wysłać rozwiązania'
    end
    redirect_to [@task.course, @task]
  end

  def update
    if solution.update(solution_params)
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

  def set_create_params
    @task = Task.find(params[:solution][:task_id])
    @content = params[:solution][:content]
  end

  def solution_params
    params.require(:solution).permit(:earned_points)
  end

  def require_correct_user
    return if current_user? solution.student
    return if current_user? course.teacher
    deny_access
  end

  def require_correct_student
    return if @task.can_be_solved_by?(current_user)
    deny_access
  end
end
