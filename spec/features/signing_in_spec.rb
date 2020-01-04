require 'rails_helper'

RSpec.feature 'Signing in' do
  subject { page }
  let(:user) { create :user }
  let(:protected_page) { edit_user_registration_path }

  scenario 'with invalid attributes' do
    visit root_path
    click_link 'Zaloguj'

    should have_heading 'Logowanie'

    click_button 'Zaloguj'

    should have_heading 'Logowanie'
    should have_warning_message
  end

  scenario 'with valid attributes', js: true do
    visit root_path
    click_link 'Zaloguj'
    fill_in 'Email', with: user.email
    fill_in 'Hasło', with: user.password
    click_button 'Zaloguj'

    expect(current_path).to eq root_path

    click_link user.name
    should have_link 'Mój profil', href: user_path(user)
    should have_link 'Ustawienia', href: edit_user_registration_path
    should have_link 'Wyloguj', href: destroy_user_session_path
    should_not have_link 'Zaloguj', href: new_user_session_path

    click_link 'Wyloguj'
    should have_link 'Zaloguj', href: new_user_session_path
    should_not have_link user.name
  end

  scenario 'forwarding when attempting to visit a protected page', js: true do
    visit protected_page
    fill_in 'Email', with: user.email
    fill_in 'Hasło', with: user.password
    click_button 'Zaloguj'

    expect(current_path).to eq protected_page

    click_link user.name
    click_link 'Wyloguj'
    sign_in user

    expect(current_path).to eq root_path
  end
end
