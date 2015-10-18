class SolutionsController < ApplicationController
  before_action :set_solution, only: [:show, :edit, :update, :destroy]
  before_action :set_create_params, only: [:create]
  before_action :require_sign_in
  before_action :require_correct_user, only: [:show]
  before_action :require_correct_teacher, only: [:edit, :update, :destroy]
  before_action :require_correct_student, only: [:create]

  def create
    if @task.solve content: @content, student: current_user
      flash[:success] = 'Rozwiązanie zostało wysłane'
    else
      flash[:danger] = 'Nie udało się wysłać rozwiązania'
    end
    redirect_to [@task.course, @task]
  end

  def update
    if @solution.update(solution_params)
      flash[:success] = 'Rozwiązanie zostało ocenione'
      redirect_to @solution
    else
      render :edit
    end
  end

  def destroy
    @solution.destroy
    flash[:success] = 'Rozwiązanie zostało usunięte'
    redirect_to solutions_course_task_path(@task.course, @task)
  end

  private

  def set_solution
    @solution = Solution.find(params[:id])
    @task = @solution.task
  end

  def set_create_params
    @task = Task.find(params[:solution][:task_id])
    @content = params[:solution][:content]
  end

  def solution_params
    params.require(:solution).permit(:earned_points)
  end

  def require_correct_user
    return if current_user? @solution.student
    return if current_user? @task.course.teacher
    raise AccessDenied
  end

  def require_correct_teacher
    raise AccessDenied unless current_user? @task.course.teacher
  end

  def require_correct_student
    return if @task.course.has_student?(current_user) && !@task.solved_by?(current_user)
    raise AccessDenied
  end
end
