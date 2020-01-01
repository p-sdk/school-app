require 'rails_helper'

RSpec.feature 'User views home page' do
  subject { page }

  background do
    sign_in user if user
    visit root_path
  end

  context 'when not signed in' do
    let(:user) { nil }

    scenario 'sees welcome message' do
      should have_heading 'Witaj na e-kursy'
    end
  end

  context 'when signed in as student' do
    let(:courses) { create_list :course, 3 }
    let(:user) { create :student, course: courses }

    scenario 'successfully' do
      should have_link 'Moje kursy', href: root_path
      should_not have_link 'Utwórz nowy kurs', href: new_course_path

      should have_heading 'Kursy na które jesteś zapisany'
      courses.each do |course|
        expect(page).to have_link course.name, href: course_path(course)
      end
    end
  end

  context 'when signed in as teacher' do
    let(:teacher) { create :teacher_with_courses }
    let(:user) { teacher }

    scenario 'successfully' do
      should have_heading 'Kursy które prowadzisz'
      teacher.teacher_courses.each do |course|
        expect(page).to have_link course.name, href: course_path(course)
      end
    end
  end

  context 'when signed in as admin' do
    let(:user) { create :admin }

    scenario 'successfully' do
      should have_link 'Zarządzaj kategoriami', href: categories_path
      should have_link 'Zarządzaj użytkownikami', href: users_path
    end
  end
end
