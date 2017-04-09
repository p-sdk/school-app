require 'rails_helper'

RSpec.feature 'Teacher deletes a solution', type: :feature do
  subject { page }

  let(:course) { create :course }
  let(:enrollment) { create :enrollment, course: course }
  let(:task) { create :task, course: course }
  let(:solution) { create :solution, enrollment: enrollment, task: task }

  before do
    sign_in_as course.teacher
    visit edit_solution_path(solution)
  end

  it 'should delete the solution' do
    expect { click_link 'Usuń' }.to change(Solution, :count).by(-1)
  end

  context 'after deleting' do
    before { click_link 'Usuń' }
    it 'should display success message' do
      expect(current_path).to eq solutions_course_task_path(course, task)
      should have_success_message
    end
  end
end
