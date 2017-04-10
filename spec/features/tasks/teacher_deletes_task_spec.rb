require 'rails_helper'

RSpec.feature 'Teacher deletes a task', type: :feature do
  subject { page }

  let(:course) { create :course }
  let(:task) { create :task, course: course }

  before do
    sign_in_as course.teacher
    visit edit_course_task_path(course, task)
  end

  it 'should delete the task' do
    expect { click_link 'Usuń' }.to change(Task, :count).by(-1)
  end

  context 'after deleting' do
    before { click_link 'Usuń' }
    it 'should display success message' do
      expect(current_path).to eq course_tasks_path(course)
      should have_success_message
    end
  end
end