require 'rails_helper'

RSpec.feature 'User views task solutions', type: :feature do
  subject { page }

  let(:task) { create :task }
  let(:course) { task.course }
  let(:enrollments) { create_list :enrollment, 5, course: course }
  let!(:ungraded_solutions) do
    enrollments.first(3).map { |e| create :solution, enrollment: e, task: task }
  end
  let!(:graded_solutions) do
    enrollments.last(2).map { |e| create :graded_solution, enrollment: e, task: task }
  end
  let(:ungraded_solution) { ungraded_solutions.first }
  let(:graded_solution) { graded_solutions.first }

  background do
    sign_in user
    visit course_task_path(course, task)
  end

  context 'when signed in as the teacher' do
    let(:user) { course.teacher }

    scenario 'successfully' do
      click_link 'Rozwiązania'

      should have_heading task.title
      should have_link course.name, href: course_path(course)
      should have_link task.title, href: course_task_path(course, task)

      should have_heading 'Rozwiązania oczekujące na sprawdzenie'
      ungraded_solutions.each do |solution|
        expect(page).to have_link solution.student_name, href: edit_solution_path(solution)
      end

      should have_heading 'Ocenione rozwiązania'
      graded_solutions.each do |solution|
        expect(page).to have_link solution.student_name, href: solution_path(solution)
      end

      click_link graded_solution.student_name

      expect(current_path).to eq solution_path(graded_solution)
      should have_heading task.title
      should have_heading 'Opis'
      should have_selector 'div.desc', text: task.desc
      should have_heading 'Rozwiązanie'
      should have_selector 'div.solution', text: graded_solution.content
      should have_content 'Uzyskane punkty'
      should have_selector 'div.points', text: "#{graded_solution.earned_points} / #{task.points}"
      should have_link 'Usuń', href: solution_path(graded_solution)

      click_link 'Rozwiązania', href: course_task_solutions_path(course, task)
      click_link ungraded_solution.student_name

      expect(current_path).to eq edit_solution_path(ungraded_solution)
    end
  end

  context 'when signed in as student with ungraded solution' do
    let(:user) { ungraded_solution.student }

    scenario 'successfully' do
      click_link 'Moje rozwiązanie'

      should have_link task.title, href: course_task_path(course, task)
      should_not have_link 'Rozwiązania'
      should_not have_link 'Usuń'
      should have_content 'Rozwiązanie czeka na sprawdzenie'
    end
  end

  context 'when signed in as student with graded solution' do
    let(:user) { graded_solution.student }

    scenario 'successfully' do
      click_link 'Moje rozwiązanie'

      should have_link task.title, href: course_task_path(course, task)
      should_not have_link 'Rozwiązania'
      should_not have_link 'Usuń'
      should have_selector 'div.points', text: "#{graded_solution.earned_points} / #{task.points}"
    end
  end
end
