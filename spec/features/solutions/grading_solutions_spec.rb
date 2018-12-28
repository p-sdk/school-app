require 'rails_helper'

RSpec.feature 'Teacher grades a solution', type: :feature do
  subject { page }

  let(:solution) { create :solution }
  let(:task) { solution.task }
  let(:course) { task.course }

  background do
    sign_in course.teacher
    visit course_task_solutions_path(course, task)
    click_link solution.student_name
  end

  scenario 'with invalid attributes' do
    should have_heading task.title
    should have_link 'Rozwiązania', href: course_task_solutions_path(course, task)
    should have_heading 'Opis'
    should have_selector 'div.desc', text: task.desc
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
    fill_in 'Uzyskane punkty', with: rand(0..task.points)
    click_button 'Oceń'

    should have_heading 'Uzyskane punkty'
    should have_selector 'div.points', text: "#{solution.earned_points} / #{solution.task.points}"
    should have_success_message
  end
end
