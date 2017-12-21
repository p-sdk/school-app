require 'rails_helper'

RSpec.feature 'Teacher updates a lecture', type: :feature do
  subject { page }

  let(:lecture) { create :lecture }
  let(:course) { lecture.course }

  before do
    sign_in course.teacher
    visit edit_course_lecture_path(course, lecture)
  end

  describe 'page' do
    it do
      should have_heading course.name
      should have_heading 'Edytuj wykład'
      should have_link 'Wróć', href: course_lecture_path(course, lecture)
    end
  end

  context 'with invalid information' do
    before do
      fill_in 'Tytuł', with: ''
      click_button 'Zapisz zmiany'
    end

    it 'should display error message' do
      should have_heading 'Edytuj wykład'
      should have_error_message
    end
  end

  context 'with valid information' do
    let(:new_content) { 'Officia deserunt mollit' }

    before do
      fill_in 'Treść', with: new_content
      click_button 'Zapisz zmiany'
    end

    it 'should display success message' do
      should have_heading lecture.title
      should have_selector 'div.lecture', text: new_content
      should have_success_message
    end
  end
end
