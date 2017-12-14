require 'rails_helper'

RSpec.feature 'User reads tasks index', type: :feature do
  subject { page }

  let(:course) { create :course }

  before do
    sign_in course.teacher
    visit course_tasks_path(course)
  end

  it 'should display a header' do
    should have_selector 'h1', text: course.name
    should have_link 'Wróć', href: course_path(course)
    should have_selector 'h2', text: 'Zadania'
  end

  context 'when there are some tasks' do
    let!(:tasks) { create_list :task, 3, course: course }
    before { visit course_tasks_path(course) }
    it 'should list course tasks' do
      tasks.each do |task|
        expect(page).to have_link task.title, href: course_task_path(course, task)
      end
    end
  end

  context 'when signed in as teacher' do
    it { should have_link 'Dodaj zadanie', href: new_course_task_path(course) }
  end

  context 'when signed in as student' do
    let!(:tasks) { create_list :task, 3, course: course }
    let(:enrollment) { create :enrollment, course: course }
    before { sign_in enrollment.student }

    describe 'task statuses' do
      before { visit course_tasks_path(course) }
      it 'should be displayed' do
        should have_selector '.task-status', count: tasks.size
      end
    end

    describe 'course grade' do
      before { visit course_tasks_path(course) }
      it 'should display earned / max points for the course' do
        should have_content 'Twój wynik'
        should have_selector '.earned-points'
        should have_selector '.max-points'
      end
    end
  end
end
