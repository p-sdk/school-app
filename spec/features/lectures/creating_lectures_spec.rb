require 'rails_helper'

RSpec.feature 'Teacher creates a lecture', type: :feature do
  subject { page }

  let(:course) { create :course }
  let(:lecture_attributes) { attributes_for :lecture }
  let(:file) { 'spec/fixtures/foo.html' }

  background do
    sign_in course.teacher
    visit course_path(course)
    click_link 'Dodaj wykład'
  end

  scenario 'with invalid attributes' do
    should have_heading 'Utwórz nowy wykład'
    should have_link course.name, href: course_path(course)

    expect { click_button 'Utwórz wykład' }.not_to change(Lecture, :count)

    should have_heading 'Utwórz nowy wykład'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Tytuł', with: lecture_attributes[:title]
    fill_in 'Treść', with: lecture_attributes[:content]
    attach_file 'Załącznik', file

    expect { click_button 'Utwórz wykład' }.to change(Lecture, :count).by(1)

    should have_heading lecture_attributes[:title]
    should have_success_message

    click_link File.basename(file)

    should have_css 'p', text: 'Foo bar baz'
  end
end
