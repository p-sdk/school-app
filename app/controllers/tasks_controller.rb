class TasksController < ApplicationController
  before_action :set_course
  before_action :set_task, only: [:show, :edit, :update, :destroy, :solutions]
  before_action :require_sign_in
  before_action :require_correct_user, only: [:index, :show]
  before_action :require_correct_teacher, only: [:new, :edit, :create, :update, :destroy, :solutions]

  def index
    @tasks = @course.tasks
  end

  def show
    @solution = @task.solution_by current_user
  end

  def new
    @task = @course.tasks.build
  end

  def edit
  end

  def create
    @task = @course.tasks.build(task_params)
    if @task.save
      flash[:success] = 'Zadanie zostało utworzone'
      redirect_to [@course, @task]
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Zadanie zostało zaktualizowane'
      redirect_to [@course, @task]
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'Zadanie zostało usunięte'
    redirect_to course_tasks_path(@course)
  end

  def solutions
    @pending_solutions = @task.solutions.ungraded
    @graded_solutions = @task.solutions.graded
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_task
    @task = @course.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :desc, :points)
  end

  def require_correct_user
    return if current_user? @course.teacher
    return if @course.has_student? current_user
    raise AccessDenied
  end

  def require_correct_teacher
    raise AccessDenied unless current_user? @course.teacher
  end
end
