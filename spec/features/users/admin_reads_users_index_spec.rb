require 'rails_helper'

RSpec.feature 'Admin reads users index', type: :feature do
  subject { page }

  let(:admin) { create :admin }
  let!(:students) { create_list :user, 2 }
  let!(:teachers) { create_list :teacher, 2 }
  let!(:requesting_upgrade_users) { create_list :teacher, 2, upgrade_request_sent_at: Time.current }

  before do
    sign_in_as admin
    visit users_path
  end

  it { should have_selector 'h1', text: 'Użytkownicy' }

  it 'should list all users requesting upgrade' do
    requesting_upgrade_users.each do |user|
      expect(page).to have_link user.name, href: user_path(user)
    end
  end

  it 'should list all teachers' do
    teachers.each do |teacher|
      expect(page).to have_link teacher.name, href: user_path(teacher)
    end
  end

  it 'should list all students' do
    students.each do |student|
      expect(page).to have_link student.name, href: user_path(student)
    end
  end
end
