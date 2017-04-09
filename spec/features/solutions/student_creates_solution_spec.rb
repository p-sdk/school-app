require 'rails_helper'

RSpec.feature 'Student creates a solution', type: :feature do
  subject { page }

  let(:course) { create :course }
  let(:enrollment) { create :enrollment, course: course }
  let(:task) { create :task, course: course }
  let(:submit) { 'Wyślij' }

  before do
    sign_in_as enrollment.student
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
    let(:valid_solution) { build :solution }
    before { fill_in 'Rozwiązanie', with: valid_solution.content }

    it 'should create solution' do
      expect { click_button submit }.to change(Solution, :count).by(1)
    end

    describe 'after submission' do
      before { click_button submit }
      it { should have_success_message }
    end
  end
end
