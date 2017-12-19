require 'rails_helper'

RSpec.feature 'Teacher creates a lecture', type: :feature do
  subject { page }

  let(:course) { create :course }

  before do
    sign_in course.teacher
    visit new_course_lecture_path(course)
  end

  describe 'page' do
    it do
      should have_selector 'h1', text: course.name
      should have_link 'Wróć', href: course_lectures_path(course)
      should have_selector 'h2', text: 'Utwórz nowy wykład'
    end
  end

  describe 'with invalid information' do
    it 'should not create a lecture' do
      expect { click_button 'Utwórz wykład' }.not_to change(Lecture, :count)
    end

    describe 'after submission' do
      before { click_button 'Utwórz wykład' }
      it 'should display error message' do
        should have_selector 'h2', text: 'Utwórz nowy wykład'
        should have_error_message
      end
    end
  end

  describe 'with valid information' do
    let(:lecture_attributes) { attributes_for :lecture }
    let(:file) { 'spec/fixtures/foo.html' }

    before do
      fill_in 'Tytuł', with: lecture_attributes[:title]
      fill_in 'Treść', with: lecture_attributes[:content]
      attach_file 'Załącznik', file
    end

    it 'should create a lecture' do
      expect { click_button 'Utwórz wykład' }.to change(Lecture, :count).by(1)
    end

    describe 'after submission' do
      before { click_button 'Utwórz wykład' }
      it 'should display success message' do
        should have_selector 'h2', text: lecture_attributes[:title]
        should have_content File.basename(file)
        should have_success_message
      end
    end
  end
end
