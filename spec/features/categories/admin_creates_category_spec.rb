require 'rails_helper'

RSpec.feature 'Admin creates a category', type: :feature do
  subject { page }

  let(:admin) { create :admin }

  before do
    sign_in_as admin
    visit new_category_path
  end

  describe 'page' do
    it do
      should have_selector 'h1', text: 'Utwórz nową kategorię'
      should have_link 'Wróć', href: categories_path
    end
  end

  context 'with invalid information' do
    it 'should not create a category' do
      expect { click_button 'Utwórz kategorię' }.not_to change(Category, :count)
    end

    describe 'after submission' do
      before { click_button 'Utwórz kategorię' }
      it 'should display error message' do
        should have_selector 'h1', text: 'Utwórz nową kategorię'
        should have_error_message
      end
    end
  end

  context 'with valid information' do
    let(:valid_category) { build :category }
    before do
      fill_in 'Nazwa', with: valid_category.name
    end

    it 'should create a category' do
      expect { click_button 'Utwórz kategorię' }.to change(Category, :count).by(1)
    end

    describe 'after submission' do
      before { click_button 'Utwórz kategorię' }
      it 'should display success message' do
        should have_selector 'h1', text: valid_category.name
        should have_success_message
      end
    end
  end
end
