require 'rails_helper'

RSpec.feature 'Student creates a solution', type: :feature do
  subject { page }

  let(:task) { create :task }
  let(:course) { task.course }
  let(:student) { u = create :user; u.enroll_in course; u }
  let(:submit) { 'Wyślij' }

  before do
    sign_in_as student
    visit course_task_path(course, task)
  end

  context 'with invalid information' do
    it 'should not create solution' do
      expect { click_button submit }.not_to change(Solution, :count)
    end

    describe 'after submission' do
      before { click_button submit }
      it { should have_error_message }
    end
  end

  context 'with valid information' do
    before { fill_in 'Rozwiązanie', with: 'Lorem Ipsum' }

    it 'should create solution' do
      expect { click_button submit }.to change(Solution, :count).by(1)
    end

    describe 'after submission' do
      before { click_button submit }
      it { should have_success_message }
    end
  end
end
