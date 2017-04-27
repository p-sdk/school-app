require 'rails_helper'

RSpec.feature 'User reads task details', type: :feature do
  subject { page }

  let(:task) { create :task }
  let(:course) { task.course }
  let(:enrollment) { create :enrollment, course: course }

  before do
    login_as enrollment.student
    visit course_task_path(course, task)
  end

  it 'should display the task' do
    should have_selector 'h1', text: course.name
    should have_selector 'h2', text: task.title
    should have_selector 'div.points', text: "Punktów do zdobycia: #{task.points}"
    should have_selector 'div.desc', text: task.desc
    should have_link 'Wróć', href: course_tasks_path(course)
  end

  context 'for enrolled student' do
    it "should not display teacher's links" do
      should_not have_link 'Edytuj'
      should_not have_link 'Rozwiązania'
    end

    context 'with unsolved task' do
      it 'should display a solution form' do
        should have_selector 'form.new_solution'
        should_not have_link 'Moje rozwiązanie'
      end
    end

    context 'with solved task' do
      before do
        create :solution, enrollment: enrollment, task: task
        visit course_task_path(course, task)
      end
      it 'should display link to submitted solution' do
        should_not have_selector 'form.new_solution'
        should have_link 'Moje rozwiązanie'
      end
    end
  end

  context 'for the teacher' do
    before do
      login_as course.teacher
      visit course_task_path(course, task)
    end

    it "should display teacher's links" do
      should have_link 'Edytuj', href: edit_course_task_path(course, task)
      should have_link 'Rozwiązania', href: course_task_solutions_path(course, task)
      should_not have_selector 'form.new_solution'
      should_not have_link 'Moje rozwiązanie'
    end

    describe 'average score' do
      let(:enrollments) { create_list :enrollment, 5, course: task.course }
      let(:solutions) do
        enrollments.map { |e| create :graded_solution, task: task, enrollment: e }
      end
      let!(:avg) { solutions.map(&:earned_points).sum / solutions.size }
      before { visit course_task_path(course, task) }
      it { should have_selector '.avg-score', text: "Przeciętny wynik: #{avg}" }
    end
  end
end
