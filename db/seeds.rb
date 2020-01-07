require_relative '../lib/faker_helper'
include FakerHelper

class Seeds
  def self.run(&block)
    start_time = Time.now

    new.instance_eval(&block)

    end_time = Time.now
    execution_time = end_time - start_time
    puts "Seeds created in #{execution_time} seconds."
  end

  private

  # @param things [Symbol] the table name, plural
  def create(table, *args)
    send "create_#{table}", *args
    log_table_count(table)
  end

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
    User.student.each do |student|
      courses = Course.all.sample(per_student)
      courses.each do |course|
        Enrollment.create! student: student, course: course
      end
    end
  end

  def create_lectures(per_course:)
    Course.all.each do |course|
      per_course.times do
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
      per_course.times do
        Task.create! task_params(course: course)
      end
    end
  end

  def create_users(num_teachers:, num_students:)
    1.upto(num_teachers) { |i| User.create! teacher_params(i) }
    1.upto(num_students) { |i| User.create! student_params(i) }
    User.create! admin_params
  end

  def admin_params
    {
      name: 'Admin',
      email: "admin@example.com",
      role: :admin
    }.reverse_merge(user_params)
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
      teacher: User.teacher.sample
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

  def student_params(num)
    {
      name: random_name,
      email: "student#{num}@example.com",
      role: :student
    }.reverse_merge(user_params)
  end

  def task_params(course:)
    {
      course: course,
      title: random_sentence,
      desc: random_text,
      points: rand(1..10) * 10
    }
  end

  def teacher_params(num)
    {
      name: random_teacher_name,
      email: "teacher#{num}@example.com",
      role: :teacher
    }.reverse_merge(user_params)
  end

  def user_params
    {
      password: 'foobar',
      password_confirmation: 'foobar',
      confirmed_at: Time.zone.now
    }
  end
end

Seeds.run do
  create :users, num_teachers: 4, num_students: 100
  create :categories, num_categories: 3
  create :courses, num_courses: 10
  create :enrollments, per_student: 3
  create :lectures, per_course: 5
  create :tasks, per_course: 5
  create :solutions
end
