require 'rails_helper'

RSpec.feature 'User views tasks', type: :feature do
  subject { page }

  let(:course) { create :course_with_tasks }
  let(:tasks) { course.tasks }
  let(:task) { tasks.first }
  let(:user) { course.teacher }

  background do
    sign_in user
    visit course_path(course)
  end

  scenario 'successfully' do
    within '#tasks' do
      should have_heading 'Zadania'
      tasks.each do |task|
        expect(page).to have_link task.title, href: course_task_path(course, task)
      end
    end

    click_link task.title

    should have_heading task.title
    should have_link course.name, href: course_path(course)
  end

  context 'when signed in as the teacher' do
    scenario 'successfully' do
      click_link task.title

      should have_link 'Rozwiązania', href: course_task_solutions_path(course, task)
      should_not have_selector 'form.new_solution'
      should_not have_link 'Moje rozwiązanie'
      should have_selector '.avg-score'
      should have_selector '.points'
      should have_selector '.description'
    end
  end

  context 'when signed in as course student' do
    let(:enrollment) { create :enrollment, course: course }
    let(:user) { enrollment.student }

    scenario 'successfully' do
      should have_selector '.task-status-badge', count: tasks.size
      should have_content 'Twój wynik'
      should have_selector '.score'

      click_link task.title

      should_not have_link 'Edytuj'
      should_not have_link 'Rozwiązania'
      should have_selector '.points'
      should have_selector '.description'
    end

    context 'with unsolved task' do
      scenario 'display a solution form' do
        click_link task.title

        should have_selector 'form.new_solution'
        should_not have_link 'Moje rozwiązanie'
        should_not have_selector '.score'
      end
    end

    context 'with solved task' do
      let(:enrollment) do
        create :enrollment_with_solution, course: course, task_to_solve: task
      end

      scenario 'display link to submitted solution' do
        click_link task.title

        should_not have_selector 'form.new_solution'
        should have_link 'Moje rozwiązanie'
        should_not have_selector '.score'
      end
    end

    context 'with graded task' do
      let(:earned_points) { task.points / 2 }
      let(:enrollment) do
        create :enrollment_with_solution,
               course: course,
               task_to_solve: task,
               earned_points: earned_points
      end

      scenario 'display task score' do
        click_link task.title

        should_not have_selector 'form.new_solution'
        should have_link 'Moje rozwiązanie'
        should have_selector '.score'
      end
    end
  end
end
