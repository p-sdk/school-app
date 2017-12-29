require 'rails_helper'

RSpec.feature 'User signs up', type: :feature do
  subject { page }

  let(:user_attributes) { attributes_for :user }

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
    fill_in 'Imię i nazwisko', with: user_attributes[:name]
    fill_in 'Email', with: user_attributes[:email]
    fill_in 'Hasło', with: user_attributes[:password]
    fill_in 'Potwierdzenie hasła', with: user_attributes[:password_confirmation]

    expect { click_button 'Załóż konto' }.to change(User, :count).by(1)

    should have_link 'Przeglądaj kursy', href: courses_path
    should have_link 'Wyloguj'
    should have_success_message
  end
end
