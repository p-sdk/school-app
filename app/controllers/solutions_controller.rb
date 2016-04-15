class SolutionsController < ApplicationController
  expose(:solution, attributes: :solution_params)
  expose(:task) { solution.task }

  before_action :set_create_params, only: :create
  before_action :require_sign_in
  before_action :require_correct_user, only: :show
  before_action :require_correct_teacher, only: %i(edit update destroy)
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
    if solution.save
      flash[:success] = 'Rozwiązanie zostało ocenione'
      redirect_to solution
    else
      render :edit
    end
  end

  def destroy
    solution.destroy
    flash[:success] = 'Rozwiązanie zostało usunięte'
    redirect_to solutions_course_task_path(task.course, task)
  end

  private

  def set_create_params
    @task = Task.find(params[:solution][:task_id])
    @content = params[:solution][:content]
  end

  def solution_params
    params.require(:solution).permit(:earned_points)
  end

  def require_correct_user
    return if current_user? solution.student
    return if current_user? task.course.teacher
    raise AccessDenied
  end

  def require_correct_teacher
    raise AccessDenied unless current_user? task.course.teacher
  end

  def require_correct_student
    return if @task.can_be_solved_by?(current_user)
    raise AccessDenied
  end
end
