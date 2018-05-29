require 'rails_helper'

RSpec.feature 'User views users', type: :feature do
  subject { page }

  let!(:students) { create_list :user, 2 }
  let!(:teachers) { create_list :teacher_with_courses, 2 }
  let!(:requesting_upgrade_users) { create_list :user_requesting_upgrade, 2 }
  let(:teacher) { teachers.first }

  background do
    sign_in user if user
  end

  context 'when signed in as a teacher' do
    let(:user) { teacher }
    let(:course) { teacher.teacher_courses.first }
    let!(:students) { create_list :student, 3, course: course }
    let(:student) { students.first }

    scenario 'view course students' do
      visit course_path(course)
      click_link 'Studenci'

      should have_heading 'Zapisani studenci'
      should have_link course.name, href: course_path(course)
      students.each do |student|
        expect(page).to have_link student.name, href: user_path(student)
      end

      click_link student.name

      should have_heading student.name
      should have_link student.email
      should have_selector 'div#avatar img.gravatar'
    end
  end

  context 'when signed in as an admin' do
    let(:user) { create :admin }

    scenario 'successfully' do
      visit root_path
      click_link 'Zarządzaj użytkownikami'

      should have_heading 'Użytkownicy'
      requesting_upgrade_users.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
      teachers.each do |teacher|
        expect(page).to have_link teacher.name, href: user_path(teacher)
      end
      students.each do |student|
        expect(page).to have_link student.name, href: user_path(student)
      end

      click_link teacher.name

      should have_link 'Użytkownicy', href: users_path
      teacher.teacher_courses.each do |course|
        expect(page).to have_link course.name, href: course_path(course)
      end
    end
  end
end
