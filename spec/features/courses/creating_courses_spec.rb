require 'rails_helper'

RSpec.feature 'Teacher creates a course', type: :feature do
  subject { page }

  let!(:category) { create :category }
  let(:teacher) { create :teacher }
  let(:course_attributes) { attributes_for :course }

  background do
    sign_in teacher
    visit root_path
    click_link 'Utwórz nowy kurs'
  end

  scenario 'with invalid attributes' do
    should have_heading 'Utwórz nowy kurs'
    should have_link 'Wróć', href: root_path

    expect { click_button 'Utwórz kurs' }.to_not change(Course, :count)

    should have_heading 'Utwórz nowy kurs'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Nazwa', with: course_attributes[:name]
    fill_in 'Opis', with: course_attributes[:desc]
    select category[:name], from: 'Kategoria'

    expect { click_button 'Utwórz kurs' }.to change(Course, :count).by(1)

    should have_heading course_attributes[:name]
    should have_success_message
  end
end
