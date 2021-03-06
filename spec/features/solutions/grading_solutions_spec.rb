require 'rails_helper'

RSpec.feature 'Teacher grades a solution' do
  subject { page }

  let(:solution) { create :solution }
  let(:task) { solution.task }
  let(:course) { task.course }
  let(:earned_points) { task.points / 2 }

  background do
    sign_in course.teacher
    visit course_task_solutions_path(course, task)
    click_link solution.student_name
  end

  scenario 'with invalid attributes' do
    should have_heading task.title
    should have_link 'Rozwiązania', href: course_task_solutions_path(course, task)
    should have_heading 'Rozwiązanie'
    should have_selector 'div.solution', text: solution.content
    should have_content 'Uzyskane punkty'
    should have_content "(0 - #{task.points})"

    fill_in 'Uzyskane punkty', with: 2 * task.points
    click_button 'Oceń'

    should have_error_message

    fill_in 'Uzyskane punkty', with: 'abc'
    click_button 'Oceń'

    should have_error_message

    fill_in 'Uzyskane punkty', with: ''
    click_button 'Oceń'

    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Uzyskane punkty', with: earned_points
    click_button 'Oceń'

    should have_content earned_points
    should have_success_message
  end
end
