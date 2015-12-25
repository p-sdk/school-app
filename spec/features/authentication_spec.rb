require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  subject { page }

  describe 'signin' do
    before { visit signin_path }

    describe 'page' do
      it { should have_selector 'h1', text: 'Logowanie' }
    end

    context 'with invalid information' do
      before { click_button 'Zaloguj' }

      it 'should display error message' do
        should have_selector 'h1', text: 'Logowanie'
        should have_error_message
      end
    end

    context 'with valid information' do
      let!(:user) { create :user }
      before { sign_in_as user }

      it 'should be signed in' do
        expect(current_path).to eq root_path
        should have_link user.name, href: '#'
        should have_link 'Mój profil', href: user_path(user)
        should have_link 'Ustawienia', href: edit_user_path(user)
        should have_link 'Wyloguj', href: signout_path
        should_not have_link 'Zaloguj', href: signin_path
      end

      describe 'followed by signout' do
        before { click_link 'Wyloguj' }

        it 'should be signed out' do
          should have_link 'Zaloguj', href: signin_path
          should_not have_link user.name
          should_not have_link 'Mój profil'
          should_not have_link 'Ustawienia'
          should_not have_link 'Wyloguj'
        end
      end
    end
  end
end
