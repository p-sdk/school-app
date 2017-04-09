require 'rails_helper'

RSpec.feature 'User updates user profile', type: :feature do
  subject { page }

  let(:user) { create :user }

  before do
    sign_in_as user
    visit edit_user_path(user)
  end

  describe 'page' do
    it do
      should have_selector 'h1', text: 'Edytuj mój profil'
      should have_link 'rozszerzenie'
    end
  end

  context 'with invalid information' do
    before { click_button 'Zapisz zmiany' }
    it 'should display error message' do
      should have_selector 'h1', text: 'Edytuj mój profil'
      should have_error_message
    end
  end

  context 'with valid information' do
    let(:new_name) { 'New name' }
    let(:new_email) { 'new@example.com' }

    before do
      fill_in 'Imię i nazwisko', with: new_name
      fill_in 'Email', with: new_email
      fill_in 'Hasło', with: user.password
      fill_in 'Potwierdzenie hasła', with: user.password
      click_button 'Zapisz zmiany'
    end

    it 'should display success message' do
      should have_selector 'h1', text: new_name
      should have_selector 'div.email', text: new_email
      should have_link 'Wyloguj', href: signout_path
      should have_success_message
    end
  end
end
