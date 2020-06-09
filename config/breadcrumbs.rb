crumb :root do
  link t(:app_name), root_path
end

crumb :categories do
  link t('breadcrumbs.categories'), categories_path if policy(Category).index?
end

crumb :category do |category|
  link category.name, category if policy(category).show?
  parent :categories
end

crumb :new_course do
  link t('breadcrumbs.new_course')
end

crumb :courses do
  link t('breadcrumbs.courses'), courses_path if policy(Course).index?
end

crumb :course do |course|
  link course.name, course if policy(course).show?
end

crumb :lectures do |course|
  link t('breadcrumbs.lectures') if policy(course).list_lectures?
  parent course
end

crumb :lecture do |lecture|
  link lecture.title, [lecture.course, lecture] if policy(lecture).show?
  parent :lectures, lecture.course
end

crumb :tasks do |course|
  link t('breadcrumbs.tasks') if policy(course).list_tasks?
  parent course
end

crumb :task do |task|
  link task.title, [task.course, task] if policy(task).show?
  parent :tasks, task.course
end

crumb :solutions do |task|
  link t('breadcrumbs.solutions'), [task.course, task, :solutions] if policy(task).list_solutions?
  parent task
end

crumb :solution do |solution|
  link solution.student_name, solution if policy(solution).show?
  parent :solutions, solution.task
end

crumb :users do |course|
  if course
    link t('breadcrumbs.students'), [course, :students] if policy(course).list_students?
    parent course
  elsif policy(User).index?
    link t('breadcrumbs.users'), users_path
  end
end

crumb :user do |user|
  link user.name, user if policy(user).show?
  parent :users
end
