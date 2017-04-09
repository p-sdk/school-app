require 'rails_helper'

RSpec.feature 'Teacher deletes a course', type: :feature do
  subject { page }

  let(:course) { create :course }

  before do
    sign_in_as course.teacher
    visit edit_course_path(course)
  end

  it 'should delete the course' do
    expect { click_link 'Usuń' }.to change(Course, :count).by(-1)
  end

  context 'after deleting' do
    before { click_link 'Usuń' }
    it 'should display success message' do
      expect(current_path).to eq courses_path
      should have_success_message
    end
  end
end
