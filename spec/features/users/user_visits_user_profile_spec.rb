require 'rails_helper'

RSpec.feature 'User visits user profile', type: :feature do
  subject { page }

  let(:user) { create :user }
  let(:teacher) { create :teacher }
  let(:admin) { create :admin }

  before { visit user_path(user) }

  it 'should display the user' do
    should have_selector 'h1', text: user.name
    should have_link user.email
    should have_selector 'div#avatar img.gravatar'
  end

  describe 'teacher' do
    before do
      create_list :course, 3, teacher: teacher
      visit user_path(teacher)
    end

    it 'should list owned courses' do
      teacher.teacher_courses.each do |course|
        expect(page).to have_link course.name, href: course_path(course)
      end
    end
  end

  context 'when the user sent upgrade request' do
    before { user.request_upgrade }
    context 'when signed in as admin' do
      before do
        login_as admin
        visit user_path(user)
      end

      it 'should display proper links' do
        should have_link 'Wróć', href: users_path
        should have_link 'Zatwierdź'
        should have_link 'Odrzuć'
      end
    end
  end
end
