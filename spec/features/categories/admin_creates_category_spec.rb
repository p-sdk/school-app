require 'rails_helper'

RSpec.feature 'Admin creates a category', type: :feature do
  subject { page }

  let(:admin) { create :admin }

  before do
    sign_in admin
    visit new_category_path
  end

  describe 'page' do
    it do
      should have_heading 'Utwórz nową kategorię'
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
        should have_heading 'Utwórz nową kategorię'
        should have_error_message
      end
    end
  end

  context 'with valid information' do
    let(:category_attributes) { attributes_for :category }

    before do
      fill_in 'Nazwa', with: category_attributes[:name]
    end

    it 'should create a category' do
      expect { click_button 'Utwórz kategorię' }.to change(Category, :count).by(1)
    end

    describe 'after submission' do
      before { click_button 'Utwórz kategorię' }
      it 'should display success message' do
        should have_heading category_attributes[:name]
        should have_success_message
      end
    end
  end
end
