require 'rails_helper'

RSpec.feature 'User reads course details', type: :feature do
  subject { page }

  let(:course) { create :course }

  before { visit course_path(course) }

  it 'should display the course' do
    should have_selector 'h1', text: course.name
    should have_selector 'div.teacher i', text: course.teacher.name
    should have_selector 'div.desc', text: course.desc
  end

  context 'when not signed in' do
    it 'should have proper links' do
      should_not have_button 'Zapisz się'
      should_not have_link 'Edytuj', href: edit_course_path(course)
      should_not have_link 'Zapisani studenci', href: students_course_path(course)
      should_not have_link 'Wykłady', href: course_lectures_path(course)
      should_not have_link 'Zadania', href: course_tasks_path(course)
    end
  end

  context 'for the teacher' do
    before do
      sign_in_as course.teacher
      visit course_path(course)
    end

    it 'should have proper links' do
      should_not have_button 'Zapisz się'
      should have_link 'Edytuj', href: edit_course_path(course)
      should have_link 'Zapisani studenci', href: students_course_path(course)
      should have_link 'Wykłady', href: course_lectures_path(course)
      should have_link 'Zadania', href: course_tasks_path(course)
    end
  end

  context 'for students' do
    let(:student) { create :user }
    before do
      sign_in_as student
      visit course_path(course)
    end

    it { should_not have_link 'Edytuj', href: edit_course_path(course) }

    context 'when enrolled' do
      before do
        student.enroll_in(course)
        visit course_path(course)
      end

      it 'should have proper links' do
        should_not have_button 'Zapisz się'
        should_not have_link 'Zapisani studenci', href: students_course_path(course)
        should have_link 'Wykłady', href: course_lectures_path(course)
        should have_link 'Zadania', href: course_tasks_path(course)
      end
    end

    context 'when not enrolled' do
      it 'should have proper links' do
        should have_button 'Zapisz się'
        should_not have_link 'Zapisani studenci', href: students_course_path(course)
        should_not have_link 'Wykłady', href: course_lectures_path(course)
        should_not have_link 'Zadania', href: course_tasks_path(course)
      end

      describe 'enrollment' do
        specify do
          expect do
            click_button 'Zapisz się'
          end.to change(student.courses, :count).by(1)
        end
        specify do
          expect do
            click_button 'Zapisz się'
          end.to change(course.students, :count).by(1)
        end
        describe 'after submission' do
          before { click_button 'Zapisz się' }
          it { should_not have_button 'Zapisz się' }
        end
      end
    end
  end
end
