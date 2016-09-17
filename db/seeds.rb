require_relative '../lib/faker_helper'
include FakerHelper

module Seeds
  module_function

  # @param things [Symbol] the table name, plural
  def create(table, *args)
    send "create_#{table}", *args
    log_table_count(table)
  end

  private

  # @param table [Symbol] the table name, plural
  def log_table_count(table)
    model = table.to_s.classify.constantize
    puts "Created #{model.count} #{table}."
  end

  def create_categories(num_categories:)
    num_categories.times do
      Category.create! category_params
    end
  end

  def create_courses(num_courses:)
    num_courses.times do
      Course.create! course_params
    end
  end

  def create_enrollments(per_student:)
    User.students.each do |student|
      enrollments_num = rand((per_student - 5)..(per_student + 5))
      courses = Course.all.sample(enrollments_num)
      courses.each do |course|
        Enrollment.create! student: student, course: course
      end
    end
  end

  def create_lectures(per_course:)
    Course.all.each do |course|
      lectures_num = rand((per_course - 5)..(per_course + 5))
      lectures_num.times do
        Lecture.create! lecture_params(course: course)
      end
    end
  end

  def create_solutions
    Task.all.each do |task|
      task.course.enrollments.each do |enrollment|
        next if random_boolean # half of tasks is not solved
        Solution.create! solution_params(task: task, enrollment: enrollment)
      end
    end
  end

  def create_tasks(per_course:)
    Course.all.each do |course|
      tasks_num = rand((per_course - 5)..(per_course + 5))
      tasks_num.times do
        Task.create! task_params(course: course)
      end
    end
  end

  def create_users(num_teachers:, num_students:)
    num_users = num_teachers + num_students
    num_users.times do |i|
      user_params = {
        password: 'foobar',
        password_confirmation: 'foobar'
      }
      if i < num_teachers
        user_params[:name] = random_teacher_name
        user_params[:email] = "teacher#{i + 1}@example.com"
        user_params[:teacher] = true
      else
        user_params[:name] = random_name
        user_params[:email] = "student#{i + 1 - num_teachers}@example.com"
      end
      User.create! user_params
    end
  end

  def category_params
    {
      name: random_category_name
    }
  end

  def course_params
    {
      name: random_sentence,
      desc: random_text,
      category: Category.all.sample,
      teacher: User.teachers.sample
    }
  end

  def lecture_params(course:)
    {
      course: course,
      title: random_sentence,
      content: random_text
    }
  end

  def solution_params(task:, enrollment:)
    params = {
      task: task,
      enrollment: enrollment,
      content: random_text
    }

    # half of solutions is graded
    if random_boolean
      earned_points = rand(0..(task.points))
      params[:earned_points] = earned_points
    end

    params
  end

  def task_params(course:)
    {
      course: course,
      title: random_sentence,
      desc: random_text,
      points: rand(1..10) * 10
    }
  end
end

include Seeds

create :users, num_teachers: 40, num_students: 1000
create :categories, num_categories: 3
create :courses, num_courses: 100
create :enrollments, per_student: 10
create :lectures, per_course: 10
create :tasks, per_course: 10
create :solutions
