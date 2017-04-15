require 'rails_helper'

RSpec.feature 'Teacher deletes a lecture', type: :feature do
  subject { page }

  let(:lecture) { create :lecture }
  let(:course) { lecture.course }

  before do
    sign_in_as course.teacher
    visit edit_course_lecture_path(course, lecture)
  end

  it 'should delete the lecture' do
    expect { click_link 'Usuń' }.to change(Lecture, :count).by(-1)
  end

  context 'after deleting' do
    before { click_link 'Usuń' }

    it 'should display success message' do
      expect(current_path).to eq course_lectures_path(course)
      should have_success_message
    end
  end
end
