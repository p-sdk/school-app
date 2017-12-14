require 'rails_helper'

RSpec.feature 'User reads task details', type: :feature do
  subject { page }

  let(:task) { create :task }
  let(:course) { task.course }
  let(:enrollment) { create :enrollment, course: course }
  let(:user) { enrollment.student }

  before do
    sign_in user
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
      let(:enrollment) do
        create :enrollment_with_solution, course: course, task_to_solve: task
      end

      it 'should display link to submitted solution' do
        should_not have_selector 'form.new_solution'
        should have_link 'Moje rozwiązanie'
      end
    end
  end

  context 'for the teacher' do
    let(:user) { course.teacher }

    it "should display teacher's links" do
      should have_link 'Edytuj', href: edit_course_task_path(course, task)
      should have_link 'Rozwiązania', href: course_task_solutions_path(course, task)
      should_not have_selector 'form.new_solution'
      should_not have_link 'Moje rozwiązanie'
      should have_selector '.avg-score', text: 'Przeciętny wynik'
    end
  end
end
