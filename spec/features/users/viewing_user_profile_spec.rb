require 'rails_helper'

RSpec.feature 'User visits user profile', type: :feature do
  subject { page }

  let(:user) { create :user }

  before do
    sign_in admin if defined? admin
    visit user_path(user)
  end

  it 'should display the user' do
    should have_heading user.name
    should have_link user.email
    should have_selector 'div#avatar img.gravatar'
  end

  describe 'teacher' do
    let(:user) { create :teacher_with_courses }

    it 'should list owned courses' do
      user.teacher_courses.each do |course|
        expect(page).to have_link course.name, href: course_path(course)
      end
    end
  end

  context 'when the user sent upgrade request' do
    let(:user) { create :user_requesting_upgrade }
    context 'when signed in as admin' do
      let(:admin) { create :admin }

      it 'should display proper links' do
        should have_link 'Wróć', href: users_path
        should have_link 'Zatwierdź'
        should have_link 'Odrzuć'
      end
    end
  end
end
