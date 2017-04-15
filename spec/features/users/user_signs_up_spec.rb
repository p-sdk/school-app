require 'rails_helper'

RSpec.feature 'User signs up', type: :feature do
  subject { page }

  before { visit signup_path }

  describe 'page' do
    it { should have_selector 'h1', text: 'Rejestracja' }
  end

  context 'with invalid information' do
    it 'should not create a user' do
      expect { click_button 'Załóż konto' }.not_to change(User, :count)
    end

    describe 'after submission' do
      before { click_button 'Załóż konto' }
      it 'should display error message' do
        should have_selector 'h1', text: 'Rejestracja'
        should have_error_message
      end
    end
  end

  context 'with valid information' do
    let(:user_attributes) { attributes_for :user }

    before do
      fill_in 'Imię i nazwisko', with: user_attributes[:name]
      fill_in 'Email', with: user_attributes[:email]
      fill_in 'Hasło', with: user_attributes[:password]
      fill_in 'Potwierdzenie hasła', with: user_attributes[:password_confirmation]
    end

    it 'should create a user' do
      expect { click_button 'Załóż konto' }.to change(User, :count).by(1)
    end

    describe 'after submission' do
      before { click_button 'Załóż konto' }
      it 'should display success message' do
        should have_link 'Przeglądaj kursy', href: courses_path
        should have_link 'Wyloguj'
        should have_success_message
      end
    end
  end
end
