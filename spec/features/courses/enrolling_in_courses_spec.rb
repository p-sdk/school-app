require 'rails_helper'

RSpec.feature 'User enrolls in the course', type: :feature do
  subject { page }

  let(:course) { create :course }
  let(:student) { create :user }

  background do
    sign_in student
    visit course_path(course)
  end

  scenario 'successfully' do
    should_not have_heading 'Wykłady'
    should_not have_link 'Zadania', href: course_tasks_path(course)

    expect { click_button 'Zapisz się' }.to change(student.courses, :count).by(1)

    expect(current_path).to eq course_path(course)
    should have_heading 'Wykłady'
    should have_link 'Zadania', href: course_tasks_path(course)
    should_not have_button 'Zapisz się'
  end
end
