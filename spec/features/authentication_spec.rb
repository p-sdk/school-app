require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  subject { page }
  let(:user) { create :user }

  describe 'signin' do
    before { visit new_user_session_path }

    describe 'page' do
      it { should have_heading 'Logowanie' }
    end

    context 'with invalid information' do
      before { click_button 'Zaloguj' }

      it 'should display error message' do
        should have_heading 'Logowanie'
        should have_warning_message
      end
    end

    context 'with valid information' do
      before do
        fill_in 'Email', with: user.email
        fill_in 'Hasło', with: user.password
        click_button 'Zaloguj'
      end

      it 'should be signed in' do
        expect(current_path).to eq root_path
        should have_link user.name, href: '#'
        should have_link 'Mój profil', href: user_path(user)
        should have_link 'Ustawienia', href: edit_user_registration_path
        should have_link 'Wyloguj', href: destroy_user_session_path
        should_not have_link 'Zaloguj', href: new_user_session_path
      end

      describe 'followed by signout' do
        before { click_link 'Wyloguj' }

        it 'should be signed out' do
          should have_link 'Zaloguj', href: new_user_session_path
          should_not have_link user.name
          should_not have_link 'Mój profil'
          should_not have_link 'Ustawienia'
          should_not have_link 'Wyloguj'
        end
      end
    end
  end

  describe 'forwarding' do
    context 'when attempting to visit a protected page' do
      let(:protected_page) { edit_user_registration_path }
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
            sign_in user
          end
          it 'should render default page' do
            expect(current_path).to eq root_path
          end
        end
      end
    end
  end
end
