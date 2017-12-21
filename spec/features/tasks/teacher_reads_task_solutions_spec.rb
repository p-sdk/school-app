require 'rails_helper'

RSpec.feature 'Teacher reads task solutions', type: :feature do
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

  before do
    sign_in course.teacher
    visit course_task_solutions_path(course, task)
  end

  it 'should display a header' do
    should have_heading course.name
    should have_heading task.title
    should have_link 'Wróć', href: course_task_path(course, task)
  end

  it { should have_heading 'Rozwiązania oczekujące na sprawdzenie' }

  it 'lists ungraded solutions' do
    ungraded_solutions.each do |solution|
      expect(page).to have_link solution.student.name, href: edit_solution_path(solution)
    end
  end

  it { should have_heading 'Ocenione rozwiązania' }

  it 'lists graded solutions' do
    graded_solutions.each do |solution|
      expect(page).to have_link solution.student.name, href: solution_path(solution)
    end
  end
end
