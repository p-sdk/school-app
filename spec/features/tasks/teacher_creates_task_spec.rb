require 'rails_helper'

RSpec.feature 'Teacher creates a task', type: :feature do
  subject { page }

  let(:course) { create :course }

  before do
    login_as course.teacher
    visit new_course_task_path(course)
  end

  describe 'page' do
    it do
      should have_selector 'h1', text: course.name
      should have_link 'Wróć', href: course_tasks_path(course)
      should have_selector 'h2', text: 'Utwórz nowe zadanie'
    end
  end

  describe 'with invalid information' do
    it 'should not create a task' do
      expect { click_button 'Utwórz zadanie' }.not_to change(Task, :count)
    end

    describe 'after submission' do
      before { click_button 'Utwórz zadanie' }
      it 'should display error message' do
        should have_selector 'h2', text: 'Utwórz nowe zadanie'
        should have_error_message
      end
    end
  end

  describe 'with valid information' do
    let(:task_attributes) { attributes_for :task }

    before do
      fill_in 'Tytuł', with: task_attributes[:title]
      fill_in 'Opis', with: task_attributes[:desc]
      fill_in 'Liczba punktów', with: task_attributes[:points]
    end

    it 'should create a task' do
      expect { click_button 'Utwórz zadanie' }.to change(Task, :count).by(1)
    end

    describe 'after submission' do
      before { click_button 'Utwórz zadanie' }
      it 'should display success message' do
        should have_selector 'h2', text: task_attributes[:title]
        should have_success_message
      end
    end
  end
end
