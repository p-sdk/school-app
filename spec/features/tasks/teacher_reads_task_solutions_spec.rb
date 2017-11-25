require 'rails_helper'

RSpec.feature 'Teacher reads task solutions', type: :feature do
  subject { page }

  let(:task) { create :task }
  let(:course) { task.course }
  let(:enrollments) { create_list :enrollment, 3, course: course }

  before do
    sign_in course.teacher
    visit course_task_solutions_path(course, task)
  end

  it 'should display a header' do
    should have_selector 'h1', text: course.name
    should have_selector 'h2', text: task.title
    should have_link 'Wróć', href: course_task_path(course, task)
  end

  it { should have_selector 'h3', text: 'Rozwiązania oczekujące na sprawdzenie' }

  describe 'list ungraded solutions' do
    let!(:ungraded_solutions) do
      enrollments.map { |e| create :solution, enrollment: e, task: task }
    end

    before { visit course_task_solutions_path(course, task) }

    specify do
      ungraded_solutions.each do |solution|
        expect(page).to have_link solution.student.name, href: edit_solution_path(solution)
      end
    end
  end

  it { should have_selector 'h3', text: 'Ocenione rozwiązania' }

  describe 'list graded solutions' do
    let!(:graded_solutions) do
      enrollments.map { |e| create :graded_solution, enrollment: e, task: task }
    end

    before { visit course_task_solutions_path(course, task) }

    specify do
      graded_solutions.each do |solution|
        expect(page).to have_link solution.student.name, href: solution_path(solution)
      end
    end
  end
end
