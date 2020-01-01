require 'rails_helper'

RSpec.feature 'Teacher creates a course' do
  subject { page }

  let!(:category) { create :category }
  let(:teacher) { create :teacher }
  let(:course_attributes) { attributes_for :course }
  let(:name) { course_attributes[:name] }
  let(:description) { course_attributes[:desc] }

  background do
    sign_in teacher
    visit root_path
    click_link 'Utwórz nowy kurs'
  end

  scenario 'with invalid attributes' do
    should have_heading 'Utwórz nowy kurs'
    should have_link 'e-kursy', href: root_path

    expect { click_button 'Utwórz kurs' }.to_not change(Course, :count)

    should have_heading 'Utwórz nowy kurs'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Nazwa', with: name
    fill_in 'Opis', with: description
    select category[:name], from: 'Kategoria'

    expect { click_button 'Utwórz kurs' }.to change(Course, :count).by(1)

    should have_heading name
    should have_success_message
  end
end
