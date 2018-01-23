require 'rails_helper'

RSpec.feature 'Teacher deletes a task', type: :feature do
  subject { page }

  let(:task) { create :task }
  let(:course) { task.course }

  background do
    sign_in course.teacher
    visit edit_course_task_path(course, task)
  end

  scenario 'successfully' do
    expect { click_link 'Usuń' }.to change(Task, :count).by(-1)

    expect(current_path).to eq course_path(course)
    should have_success_message
  end
end
