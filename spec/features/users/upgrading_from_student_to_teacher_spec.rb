require 'rails_helper'

RSpec.feature 'User upgrades from a student to a teacher' do
  subject { page }

  let(:user) { create :user }
  let(:admin) { create :admin }

  background do
    sign_in user
    visit edit_user_registration_path
    click_link 'rozszerzenie'
  end

  scenario 'submitting request to upgrade to teacher account' do
    expect(User.requesting_upgrade).to include user
    expect(user.reload).to be_requesting_upgrade
    should have_success_message

    visit edit_user_registration_path

    should_not have_link 'rozszerzenie'
    should have_content 'czeka na rozpatrzenie'
  end

  context 'admin decides on upgrade' do
    background do
      sign_in admin
      visit users_path
      first('a', text: user.name).click
    end

    scenario 'approving' do
      click_link 'Zatwierdź'

      expect(User.requesting_upgrade).not_to include user
      expect(user.reload).to be_teacher
      should have_success_message
    end

    scenario 'dismissing' do
      click_link 'Odrzuć'

      expect(User.requesting_upgrade).not_to include user
      expect(user.reload).not_to be_teacher
      should have_success_message
    end
  end
end
