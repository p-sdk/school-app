require 'rails_helper'

RSpec.feature 'Teacher grades a solution', type: :feature do
  subject { page }

  let(:solution) { create :solution }
  let(:task) { solution.task }
  let(:course) { task.course }

  before do
    login_as course.teacher
    visit edit_solution_path(solution)
  end

  describe 'page' do
    it 'should display the solution' do
      should have_selector 'h1', text: task.title
      should have_link 'Wróć', href: course_task_solutions_path(course, task)
      should have_selector 'h3', text: 'Opis'
      should have_selector 'div.desc', text: task.desc
      should have_selector 'h3', text: 'Rozwiązanie'
      should have_selector 'div.solution', text: solution.content
      should have_content 'Uzyskane punkty'
      should have_content "(0 - #{task.points})"
      should have_link 'Usuń', href: solution_path(solution)
    end
  end

  context 'with invalid information' do
    it 'should display error message' do
      fill_in 'Uzyskane punkty', with: 2 * task.points
      click_button 'Oceń'
      should have_error_message
      fill_in 'Uzyskane punkty', with: 'abc'
      click_button 'Oceń'
      should have_error_message
      fill_in 'Uzyskane punkty', with: ''
      click_button 'Oceń'
      should have_error_message
    end
  end

  context 'with valid information' do
    before do
      fill_in 'Uzyskane punkty', with: rand(0..task.points)
      click_button 'Oceń'
    end
    it 'should display success message' do
      should have_selector 'h3', text: 'Uzyskane punkty'
      should have_selector 'div.points', text: "#{solution.earned_points} / #{solution.task.points}"
      should have_success_message
    end
  end
end
