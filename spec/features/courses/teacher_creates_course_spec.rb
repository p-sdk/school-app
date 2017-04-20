require 'rails_helper'

RSpec.feature 'Teacher creates a course', type: :feature do
  subject { page }

  let(:teacher) { create :teacher }

  before do
    login_as teacher
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
    let(:course_attributes) { attributes_for :course }

    before do
      visit new_course_path
      fill_in 'Nazwa', with: course_attributes[:name]
      fill_in 'Opis', with: course_attributes[:desc]
      select category[:name], from: 'Kategoria'
    end

    it 'should create a course' do
      expect { click_button 'Utwórz kurs' }.to change(Course, :count).by(1)
    end

    describe 'after submission' do
      before { click_button 'Utwórz kurs' }

      it 'should display success message' do
        should have_selector 'h1', text: course_attributes[:name]
        should have_success_message
      end
    end
  end
end
