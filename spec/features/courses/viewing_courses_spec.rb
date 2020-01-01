require 'rails_helper'

RSpec.feature 'User views courses' do
  subject { page }

  let!(:courses) { create_list :course, 6 }
  let(:course) { courses.first }
  let(:user) { nil }

  background do
    sign_in user if user
    visit root_path
    click_link 'Kursy'
  end

  scenario 'successfully' do
    should have_heading 'Kursy'
    should have_link 'Przeglądaj wg kategorii', href: categories_path
    courses.each do |course|
      expect(page).to have_link course.name, href: course_path(course)
    end

    click_link course.name

    should have_heading course.name
    should have_link course.category.name, href: category_path(course.category)
    should have_selector 'div.teacher i', text: course.teacher.name
    should have_selector '.description', text: course.desc
  end

  context 'when not signed in' do
    scenario 'should have proper links' do
      click_link course.name

      should_not have_button 'Zapisz się'
      should_not have_link 'Edytuj', href: edit_course_path(course)
      should_not have_link 'Studenci', href: course_students_path(course)
      should_not have_heading 'Wykłady'
      should_not have_heading 'Zadania'
    end
  end

  context 'when signed in as the teacher' do
    let(:user) { course.teacher }

    scenario 'should have proper links' do
      click_link course.name

      should_not have_button 'Zapisz się'
      should have_link 'Edytuj', href: edit_course_path(course)
      should have_link 'Studenci', href: course_students_path(course)
      should have_heading 'Wykłady'
      should have_heading 'Zadania'
    end
  end

  context 'when signed in as a student' do
    let(:user) { create :student, course: course }

    scenario 'should have proper links' do
      click_link course.name

      should_not have_link 'Edytuj', href: edit_course_path(course)
      should_not have_link 'Studenci', href: course_students_path(course)
    end
  end
end
