require 'rails_helper'

RSpec.feature 'Teacher creates a task', type: :feature do
  subject { page }

  let(:course) { create :course }
  let(:task_attributes) { attributes_for :task }
  let(:title) { task_attributes[:title] }
  let(:description) { task_attributes[:desc] }
  let(:points) { task_attributes[:points] }

  background do
    sign_in course.teacher
    visit course_path(course)
    click_link 'Dodaj zadanie'
  end

  scenario 'with invalid attributes' do
    should have_heading 'Utwórz nowe zadanie'
    should have_link course.name, href: course_path(course)

    expect { click_button 'Utwórz zadanie' }.not_to change(Task, :count)

    should have_heading 'Utwórz nowe zadanie'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Tytuł', with: title
    fill_in 'Opis', with: description
    fill_in 'Liczba punktów', with: points

    expect { click_button 'Utwórz zadanie' }.to change(Task, :count).by(1)

    should have_heading title
    should have_success_message
  end
end
