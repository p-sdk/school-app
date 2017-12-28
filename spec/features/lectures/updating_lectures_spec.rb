require 'rails_helper'

RSpec.feature 'Teacher updates a lecture', type: :feature do
  subject { page }

  let(:lecture) { create :lecture }
  let(:course) { lecture.course }
  let(:new_content) { 'Officia deserunt mollit' }

  background do
    sign_in course.teacher
    visit course_lecture_path(course, lecture)
    click_link 'Edytuj'
  end

  scenario 'with invalid attributes' do
    should have_heading course.name
    should have_heading 'Edytuj wykład'
    should have_link 'Wróć', href: course_lecture_path(course, lecture)

    fill_in 'Tytuł', with: ''
    click_button 'Zapisz zmiany'

    should have_heading 'Edytuj wykład'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Treść', with: new_content
    click_button 'Zapisz zmiany'

    should have_heading lecture.title
    should have_selector 'div.lecture', text: new_content
    should have_success_message
  end
end
