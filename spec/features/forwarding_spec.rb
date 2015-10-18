require 'rails_helper'

RSpec.feature 'Forwarding', type: :feature do
  subject { page }
  let(:user) { create :user }

  context 'when attempting to visit a protected page' do
    let(:protected_page) { edit_user_path(user) }
    before do
      visit protected_page
      fill_in 'Email', with: user.email
      fill_in 'Hasło', with: user.password
      click_button 'Zaloguj'
    end

    describe 'after signing in' do
      it 'should render the desired protected page' do
        expect(current_path).to eq protected_page
      end

      context 'when signing in again' do
        before do
          click_link 'Wyloguj'
          sign_in_as user
        end
        it 'should render default page' do
          expect(current_path).to eq root_path
        end
      end
    end
  end
end
