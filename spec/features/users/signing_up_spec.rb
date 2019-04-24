require 'rails_helper'

RSpec.feature 'User signs up', type: :feature do
  subject { page }

  let(:user_attributes) { attributes_for :user }
  let(:name) { user_attributes[:name] }
  let(:email) { user_attributes[:email] }
  let(:password) { user_attributes[:password] }

  background do
    visit root_path
    click_link 'Zarejestruj się'
  end

  scenario 'with invalid attributes' do
    should have_heading 'Rejestracja'

    expect { click_button 'Załóż konto' }.not_to change(User, :count)

    should have_heading 'Rejestracja'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Imię i nazwisko', with: name
    fill_in 'Email', with: email
    fill_in 'Hasło', with: password
    fill_in 'Potwierdzenie hasła', with: password

    expect { click_button 'Załóż konto' }.to change(User, :count).by(1)

    open_email(email)
    current_email.click_link 'Potwierdź swoje konto'

    fill_in 'Email', with: email
    fill_in 'Hasło', with: password
    click_button 'Zaloguj'

    should have_link name
    should have_link 'Przeglądaj kursy', href: courses_path
    should have_link 'Wyloguj'
    should have_success_message
  end
end
