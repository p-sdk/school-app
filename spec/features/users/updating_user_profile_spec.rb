require 'rails_helper'

RSpec.feature 'User updates user profile', type: :feature do
  subject { page }

  let(:user) { create :user }
  let(:new_name) { 'New name' }
  let(:new_email) { 'new@example.com' }

  background do
    sign_in user
    visit root_path
    click_link 'Ustawienia'
  end

  scenario 'with invalid attributes' do
    should have_heading 'Edytuj mój profil'

    click_button 'Zapisz zmiany'

    should have_heading 'Edytuj mój profil'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Imię i nazwisko', with: new_name
    fill_in 'Email', with: new_email
    fill_in 'Aktualne hasło', with: user.password
    click_button 'Zapisz zmiany'

    should have_success_message

    open_email(new_email)
    current_email.click_link 'Potwierdź swoje konto'

    visit user_path(user)

    should have_heading new_name
    should have_selector 'div.email', text: new_email
  end
end
