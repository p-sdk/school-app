require 'rails_helper'

RSpec.feature 'Teacher deletes a lecture' do
  subject { page }

  let(:lecture) { create :lecture }
  let(:course) { lecture.course }

  background do
    sign_in course.teacher
    visit edit_course_lecture_path(course, lecture)
  end

  scenario 'successfully' do
    expect { click_link 'Usuń' }.to change(Lecture, :count).by(-1)

    expect(current_path).to eq course_path(course)
    should have_success_message
  end
end
