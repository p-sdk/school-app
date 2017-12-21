require 'rails_helper'

RSpec.feature 'User visits home page', type: :feature do
  subject { page }

  let(:user) { nil }

  before do
    sign_in user if user
    visit root_path
  end

  it { should have_heading 'Witaj na e-kursy' }

  it 'should have the right links on the layout' do
    click_link 'Kursy'
    expect(page).to have_heading 'Kursy'
    click_link 'logo'
    click_link 'Zarejestruj'
    expect(page).to have_heading 'Rejestracja'
    click_link 'logo'
    expect(current_path).to eq root_path
  end

  context 'when signed in' do
    let(:user) { create :user }

    it { should have_link 'Moje kursy', href: root_path }

    context 'as student' do
      it { should_not have_link 'Utwórz nowy kurs', href: new_course_path }

      describe 'enrolled in courses' do
        let(:courses) { create_list :course, 3 }
        let(:user) { create :student, course: courses }

        it 'should list all courses that the student has enrolled in' do
          should have_heading 'Kursy na które jesteś zapisany'
          courses.each do |course|
            expect(page).to have_link course.name, href: course_path(course)
          end
        end
      end
    end

    context 'as teacher' do
      let(:teacher) { create :teacher_with_courses }
      let(:user) { teacher }

      it { should have_link 'Utwórz nowy kurs', href: new_course_path }

      describe 'owned courses' do
        it 'should show all owned courses' do
          should have_heading 'Kursy które prowadzisz'
          teacher.teacher_courses.each do |course|
            expect(page).to have_link course.name, href: course_path(course)
          end
        end
      end
    end

    context 'as admin' do
      let(:user) { create :admin }

      it 'should have proper links' do
        should have_link 'Zarządzaj kategoriami', href: categories_path
        should have_link 'Zarządzaj użytkownikami', href: users_path
      end
    end
  end
end
