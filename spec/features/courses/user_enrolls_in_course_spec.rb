require 'rails_helper'

RSpec.feature 'User enrolls in the course', type: :feature do
  subject { page }

  let(:course) { create :course }
  let(:student) { create :user }

  before do
    login_as student
    visit course_path(course)
  end

  describe 'enrollment' do
    specify do
      expect do
        click_button 'Zapisz się'
      end.to change(student.courses, :count).by(1)
    end

    specify do
      expect do
        click_button 'Zapisz się'
      end.to change(course.students, :count).by(1)
    end

    describe 'after submission' do
      before { click_button 'Zapisz się' }
      it { should_not have_button 'Zapisz się' }
    end
  end
end
