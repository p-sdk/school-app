require 'rails_helper'

RSpec.feature 'Teacher deletes a course' do
  subject { page }

  let(:course) { create :course }

  background do
    sign_in course.teacher
    visit edit_course_path(course)
  end

  scenario 'successfully' do
    expect { click_link 'Usuń' }.to change(Course, :count).by(-1)

    expect(current_path).to eq courses_path
    should have_success_message
  end
end
