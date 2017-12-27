require 'rails_helper'

RSpec.feature 'Teacher updates a task', type: :feature do
  subject { page }

  let(:task) { create :task }
  let(:course) { task.course }

  before do
    sign_in course.teacher
    visit edit_course_task_path(course, task)
  end

  describe 'page' do
    it do
      should have_heading course.name
      should have_link 'Wróć', href: course_task_path(course, task)
      should have_heading 'Edytuj zadanie'
    end
  end

  context 'with invalid information' do
    before do
      fill_in 'Tytuł', with: ''
      click_button 'Zapisz zmiany'
    end
    it 'should display error message' do
      should have_heading 'Edytuj zadanie'
      should have_error_message
    end
  end

  context 'with valid information' do
    let(:new_desc) { 'Officia deserunt mollit' }
    let(:new_points) { 60 }
    before do
      fill_in 'Opis', with: new_desc
      fill_in 'Liczba punktów', with: new_points
      click_button 'Zapisz zmiany'
    end
    it 'should display success message' do
      should have_heading task.title
      should have_selector 'div.points', text: new_points
      should have_selector 'div.desc', text: new_desc
      should have_success_message
    end
  end
end
