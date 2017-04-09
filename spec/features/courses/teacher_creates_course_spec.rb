require 'rails_helper'

RSpec.feature 'Teacher creates a course', type: :feature do
  subject { page }

  let(:teacher) { create :teacher }

  before do
    sign_in_as teacher
    visit new_course_path
  end

  describe 'page' do
    it do
      should have_selector 'h1', text: 'Utwórz nowy kurs'
      should have_link 'Wróć', href: root_path
    end
  end

  context 'with invalid information' do
    it 'should not create a course' do
      expect { click_button 'Utwórz kurs' }.to_not change(Course, :count)
    end

    describe 'after submission' do
      before { click_button 'Utwórz kurs' }
      it 'should display error message' do
        should have_selector 'h1', text: 'Utwórz nowy kurs'
        should have_error_message
      end
    end
  end

  context 'with valid information' do
    let!(:category) { create :category }
    let(:valid_course) { build :course, category: category }
    before do
      visit new_course_path
      fill_in 'Nazwa', with: valid_course.name
      fill_in 'Opis', with: valid_course.desc
      select valid_course.category.name, from: 'Kategoria'
    end

    it 'should create a course' do
      expect { click_button 'Utwórz kurs' }.to change(Course, :count).by(1)
    end

    describe 'after submission' do
      before { click_button 'Utwórz kurs' }
      it 'should display success message' do
        should have_selector 'h1', text: valid_course.name
        should have_success_message
      end
    end
  end
end
