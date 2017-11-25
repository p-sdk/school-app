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
      should_not have_link 'Zapisani studenci', href: course_students_path(course)
      should_not have_link 'Wykłady', href: course_lectures_path(course)
      should_not have_link 'Zadania', href: course_tasks_path(course)
    end
  end

  context 'for the teacher' do
    before do
      sign_in course.teacher
      visit course_path(course)
    end

    it 'should have proper links' do
      should_not have_button 'Zapisz się'
      should have_link 'Edytuj', href: edit_course_path(course)
      should have_link 'Zapisani studenci', href: course_students_path(course)
      should have_link 'Wykłady', href: course_lectures_path(course)
      should have_link 'Zadania', href: course_tasks_path(course)
    end
  end

  context 'for students' do
    let(:student) { create :user }
    before do
      sign_in student
      visit course_path(course)
    end

    it { should_not have_link 'Edytuj', href: edit_course_path(course) }

    context 'when enrolled' do
      let(:student) { create :student, course: course }

      it 'should have proper links' do
        should_not have_button 'Zapisz się'
        should_not have_link 'Zapisani studenci', href: course_students_path(course)
        should have_link 'Wykłady', href: course_lectures_path(course)
        should have_link 'Zadania', href: course_tasks_path(course)
      end
    end

    context 'when not enrolled' do
      it 'should have proper links' do
        should have_button 'Zapisz się'
        should_not have_link 'Zapisani studenci', href: course_students_path(course)
        should_not have_link 'Wykłady', href: course_lectures_path(course)
        should_not have_link 'Zadania', href: course_tasks_path(course)
      end
    end
  end
end
