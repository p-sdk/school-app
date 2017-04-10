require 'rails_helper'

RSpec.feature 'User upgrades from a student to a teacher', type: :feature do
  subject { page }

  let(:user) { create :user }

  describe 'submitting request to upgrade to teacher account' do
    before do
      sign_in_as user
      visit edit_user_path(user)
      click_on 'rozszerzenie'
    end

    it 'should be waiting for approval' do
      expect(User.requesting_upgrade).to include user
      expect(user.reload).to be_requesting_upgrade
      should have_success_message
    end

    describe 'edit page' do
      before { visit edit_user_path(user) }

      it 'should have proper message' do
        should_not have_link 'rozszerzenie'
        should have_content 'czeka na akceptację'
      end
    end
  end

  describe 'upgrade' do
    let(:admin) { create :admin }

    before do
      user.request_upgrade
      sign_in_as admin
      visit user_path(user)
    end

    context 'after approving' do
      before { click_on 'Zatwierdź' }
      it 'should upgrade the user' do
        expect(User.requesting_upgrade).not_to include user
        expect(user.reload).to be_teacher
        should have_success_message
      end
    end

    context 'after dismissing' do
      before { click_on 'Odrzuć' }
      it 'should not upgrade the user' do
        expect(User.requesting_upgrade).not_to include user
        expect(user.reload).not_to be_teacher
        should have_success_message
      end
    end
  end
end