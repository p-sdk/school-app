require 'rails_helper'

RSpec.feature 'Teacher deletes a solution' do
  subject { page }

  let(:solution) { create :solution }
  let(:task) { solution.task }
  let(:course) { task.course }

  background do
    sign_in course.teacher
    visit edit_solution_path(solution)
  end

  scenario 'successfully' do
    expect { click_link 'Usuń' }.to change(Solution, :count).by(-1)

    expect(current_path).to eq course_task_solutions_path(course, task)
    should have_success_message
  end
end
