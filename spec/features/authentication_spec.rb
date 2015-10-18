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

      it { should have_selector 'h1', text: 'Logowanie' }
      it { should have_error_message }
    end

    context 'with valid information' do
      let!(:user) { create :user }
      before { sign_in_as user }

      it 'should redirect to root path' do
        expect(current_path).to eq root_path
      end

      it { should have_link user.name, href: '#' }
      it { should have_link 'Mój profil', href: user_path(user) }
      it { should have_link 'Ustawienia', href: edit_user_path(user) }
      it { should have_link 'Wyloguj', href: signout_path }
      it { should_not have_link 'Zaloguj', href: signin_path }

      describe 'followed by signout' do
        before { click_link 'Wyloguj' }

        it { should have_link 'Zaloguj', href: signin_path }
        it { should_not have_link user.name }
        it { should_not have_link 'Mój profil' }
        it { should_not have_link 'Ustawienia' }
        it { should_not have_link 'Wyloguj' }
      end
    end
  end
end
