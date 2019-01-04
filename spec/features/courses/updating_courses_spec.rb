require 'rails_helper'

RSpec.feature 'Teacher updates a course', type: :feature do
  subject { page }

  let(:course) { create :course }
  let(:new_desc) { 'Sunt in culpa qui officia deserunt.' }

  background do
    sign_in course.teacher
    visit course_path(course)
    click_link 'Edytuj'
  end

  scenario 'with invalid attributes' do
    should have_heading 'Edytuj kurs'
    should have_link course.name, href: course_path(course)

    fill_in 'Nazwa', with: ''
    click_button 'Zapisz zmiany'

    should have_heading 'Edytuj kurs'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Opis', with: new_desc
    click_button 'Zapisz zmiany'

    should have_heading course.name
    should have_selector '.description', text: new_desc
    should have_success_message
  end
end
