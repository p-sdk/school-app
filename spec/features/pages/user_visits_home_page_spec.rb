require 'rails_helper'

RSpec.feature 'User visits home page', type: :feature do
  subject { page }

  let(:user) { create :user }
  let(:teacher) { create :teacher }
  let(:admin) { create :admin }

  before { visit root_path }

  it { should have_selector 'h1', text: 'Witaj na e-kursy' }

  it 'should have the right links on the layout' do
    click_link 'Kursy'
    expect(page).to have_selector 'h1', text: 'Kursy'
    click_link 'logo'
    click_link 'Zarejestruj'
    expect(page).to have_selector 'h1', text: 'Rejestracja'
    click_link 'logo'
    expect(current_path).to eq root_path
  end

  context 'when signed in' do
    before do
      sign_in_as user
      visit root_path
    end
    it { should have_link 'Moje kursy', href: root_path }

    context 'as student' do
      it { should_not have_link 'Utwórz nowy kurs', href: new_course_path }

      describe 'enrolled in courses' do
        let(:courses) { create_list :course, 3 }
        before do
          courses.each { |c| user.enroll_in c }
          visit root_path
        end

        it 'should list all courses that the student has enrolled in' do
          should have_selector 'h2', text: 'Kursy na które jesteś zapisany'
          courses.each do |course|
            expect(page).to have_link course.name, href: course_path(course)
          end
        end
      end
    end

    context 'as teacher' do
      before do
        sign_in_as teacher
        visit root_path
      end

      it { should have_link 'Utwórz nowy kurs', href: new_course_path }
      describe 'owned courses' do
        before do
          create_list :course, 3, teacher: teacher
          visit root_path
        end

        it 'should show all owned courses' do
          should have_selector 'h2', text: 'Kursy które prowadzisz'
          teacher.teacher_courses.each do |course|
            expect(page).to have_link course.name, href: course_path(course)
          end
        end
      end
    end

    context 'as admin' do
      before do
        sign_in_as admin
        visit root_path
      end

      it 'should have proper links' do
        should have_link 'Zarządzaj kategoriami', href: categories_path
        should have_link 'Zarządzaj użytkownikami', href: users_path
      end
    end
  end
end
