require 'rails_helper'

RSpec.feature 'Teacher updates a course', type: :feature do
  subject { page }

  let(:course) { create :course }

  before do
    sign_in_as course.teacher
    visit edit_course_path(course)
  end

  describe 'page' do
    it do
      should have_selector 'h1', text: 'Edytuj kurs'
      should have_link 'Wróć', href: course_path(course)
    end
  end

  context 'with invalid information' do
    before do
      fill_in 'Nazwa', with: ''
      click_button 'Zapisz zmiany'
    end
    it 'should display error message' do
      should have_selector 'h1', text: 'Edytuj kurs'
      should have_error_message
    end
  end

  context 'with valid information' do
    let(:new_desc) { 'Sunt in culpa qui officia deserunt mollit anim id est laborum.' }
    before do
      fill_in 'Opis', with: new_desc
      click_button 'Zapisz zmiany'
    end

    it 'should display success message' do
      should have_selector 'h1', text: course.name
      should have_selector 'div.desc', text: new_desc
      should have_success_message
    end
  end
end
