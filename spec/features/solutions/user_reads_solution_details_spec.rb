require 'rails_helper'

RSpec.feature 'User reads solution details', type: :feature do
  subject { page }

  let(:solution) { create :solution }
  let(:task) { solution.task }
  let(:course) { task.course }
  let(:user) { course.teacher }

  before do
    sign_in user
    visit solution_path(solution)
  end

  it 'should display the solution' do
    should have_heading task.title
    should have_heading 'Opis'
    should have_selector 'div.desc', text: task.desc
    should have_heading 'Rozwiązanie'
    should have_selector 'div.solution', text: solution.content
    should have_content 'Uzyskane punkty'
    should have_link 'Wróć do listy rozwiązań', href: course_task_solutions_path(course, task)
    should have_link 'Usuń', href: solution_path(solution)
  end

  context 'when signed in as student' do
    let(:user) { solution.enrollment.student }

    it 'should have proper links' do
      should have_link 'Wróć do listy zadań', href: course_tasks_path(course)
      should_not have_link 'Usuń'
    end
  end

  context 'when solution is not graded' do
    it { should have_content 'Rozwiązanie czeka na sprawdzenie' }
  end

  context 'when solution is graded' do
    let(:solution) { create :solution, earned_points: 25 }

    it { should have_selector 'div.points', text: "#{solution.earned_points} / #{task.points}" }
  end
end
