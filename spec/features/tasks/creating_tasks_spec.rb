require 'rails_helper'

RSpec.feature 'Teacher creates a task', type: :feature do
  subject { page }

  let(:course) { create :course }
  let(:task_attributes) { attributes_for :task }

  background do
    sign_in course.teacher
    visit course_tasks_path(course)
    click_link 'Dodaj zadanie'
  end

  scenario 'with invalid attributes' do
    should have_heading course.name
    should have_heading 'Utwórz nowe zadanie'
    should have_link 'Zadania', href: course_tasks_path(course)

    expect { click_button 'Utwórz zadanie' }.not_to change(Task, :count)

    should have_heading 'Utwórz nowe zadanie'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Tytuł', with: task_attributes[:title]
    fill_in 'Opis', with: task_attributes[:desc]
    fill_in 'Liczba punktów', with: task_attributes[:points]

    expect { click_button 'Utwórz zadanie' }.to change(Task, :count).by(1)

    should have_heading task_attributes[:title]
    should have_success_message
  end
end
