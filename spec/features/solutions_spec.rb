require 'rails_helper'

RSpec.feature 'Solutions', type: :feature do
  subject { page }
  let(:course) { create :course }
  let(:enrollment) { create :enrollment, course: course }
  let(:task) { create :task, course: course }
  let(:solution) { create :solution, enrollment: enrollment, task: task }

  describe 'show page' do
    before do
      sign_in_as course.teacher
      visit solution_path(solution)
    end
    it { should have_selector 'h1', text: task.title }
    it { should have_selector 'h3', text: 'Opis' }
    it { should have_selector 'div.desc', text: task.desc }
    it { should have_selector 'h3', text: 'Rozwiązanie' }
    it { should have_selector 'div.solution', text: solution.content }

    it { should have_content 'Uzyskane punkty' }
    it { should have_link 'Wróć do listy rozwiązań', href: solutions_course_task_path(course, task) }

    it { should have_link 'Usuń', href: solution_path(solution) }

    context 'when signed in as student' do
      before do
        sign_in_as enrollment.student
        visit solution_path(solution)
      end
      it { should have_link 'Wróć do listy zadań', href: course_tasks_path(course) }
      it { should_not have_link 'Usuń' }
    end

    context 'when solution is not graded' do
      it { should have_content 'Rozwiązanie czeka na sprawdzenie' }
    end

    context 'when solution is graded' do
      before do
        solution.update! earned_points: 25
        visit solution_path(solution)
      end
      it { should have_selector 'div.points', text: "#{solution.earned_points} / #{task.points}" }
    end
  end

  describe 'creating solution' do
    let(:submit) { 'Wyślij' }
    before do
      sign_in_as enrollment.student
      visit course_task_path(course, task)
    end

    context 'with invalid information' do
      it 'should not create solution' do
        expect { click_button submit }.not_to change(Solution, :count)
      end

      describe 'after submission' do
        before { click_button submit }
        it { should have_error_message }
      end
    end

    context 'with valid information' do
      let(:valid_solution) { build :solution }
      before { fill_in 'Rozwiązanie', with: valid_solution.content }

      it 'should create solution' do
        expect { click_button submit }.to change(Solution, :count).by(1)
      end

      describe 'after submission' do
        before { click_button submit }
        it { should have_success_message }
      end
    end
  end

  describe 'grading solution' do
    before do
      sign_in_as course.teacher
      visit edit_solution_path(solution)
    end

    describe 'page' do
      it { should have_selector 'h1', text: task.title }
      it { should have_link 'Wróć', href: solutions_course_task_path(course, task) }
      it { should have_selector 'h3', text: 'Opis' }
      it { should have_selector 'div.desc', text: task.desc }
      it { should have_selector 'h3', text: 'Rozwiązanie' }
      it { should have_selector 'div.solution', text: solution.content }

      it { should have_content 'Uzyskane punkty' }
      it { should have_content "(0 - #{task.points})" }

      it { should have_link 'Usuń', href: solution_path(solution) }
    end

    context 'with invalid information' do
      describe '(too many points)' do
        before do
          fill_in 'Uzyskane punkty', with: 2 * task.points
          click_button 'Oceń'
        end
        it { should have_error_message }
      end

      describe '(text instead of number)' do
        before do
          fill_in 'Uzyskane punkty', with: 'abc'
          click_button 'Oceń'
        end
        it { should have_error_message }
      end

      describe '(empty)' do
        before do
          fill_in 'Uzyskane punkty', with: ''
          click_button 'Oceń'
        end
        it { should have_error_message }
      end
    end

    context 'with valid information' do
      before do
        fill_in 'Uzyskane punkty', with: rand(0..task.points)
        click_button 'Oceń'
      end
      it { should have_selector 'h3', text: 'Uzyskane punkty' }
      it { should have_selector 'div.points', text: "#{solution.earned_points} / #{solution.task.points}" }
      it { should have_success_message }
    end
  end

  describe 'deleting solution' do
    before do
      sign_in_as course.teacher
      visit edit_solution_path(solution)
    end

    it 'should delete the solution' do
      expect { click_link 'Usuń' }.to change(Solution, :count).by(-1)
    end

    context 'after deleting' do
      before { click_link 'Usuń' }
      it { expect(current_path).to eq solutions_course_task_path(course, task) }
      it { should have_success_message }
    end
  end
end
