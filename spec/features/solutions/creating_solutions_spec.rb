require 'rails_helper'

RSpec.feature 'Student creates a solution' do
  subject { page }

  let(:task) { create :task }
  let(:course) { task.course }
  let(:student) { create :student, course: course }

  background do
    sign_in student
    visit course_task_path(course, task)
  end

  scenario 'with invalid attributes' do
    expect { click_button 'Wyślij' }.not_to change(Solution, :count)

    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Rozwiązanie', with: 'Lorem Ipsum'

    expect { click_button 'Wyślij' }.to change(Solution, :count).by(1)

    should have_success_message
  end
end
