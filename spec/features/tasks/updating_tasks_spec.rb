require 'rails_helper'

RSpec.feature 'Teacher updates a task', type: :feature do
  subject { page }

  let(:task) { create :task }
  let(:course) { task.course }
  let(:new_desc) { 'Officia deserunt mollit' }
  let(:new_points) { 60 }

  background do
    sign_in course.teacher
    visit course_task_path(course, task)
    click_link 'Edytuj'
  end

  scenario 'with invalid attributes' do
    should have_heading course.name
    should have_heading 'Edytuj zadanie'
    should have_link 'Wróć', href: course_task_path(course, task)

    fill_in 'Tytuł', with: ''
    click_button 'Zapisz zmiany'

    should have_heading 'Edytuj zadanie'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Opis', with: new_desc
    fill_in 'Liczba punktów', with: new_points
    click_button 'Zapisz zmiany'

    should have_heading task.title
    should have_selector 'div.points', text: new_points
    should have_selector 'div.desc', text: new_desc
    should have_success_message
  end
end
