require 'rails_helper'

RSpec.feature 'Admin updates a category', type: :feature do
  subject { page }

  let(:admin) { create :admin }
  let(:category) { create :category }

  before do
    sign_in admin
    visit edit_category_path(category)
  end

  describe 'page' do
    it do
      should have_heading 'Edytuj kategorię'
      should have_link 'Wróć', href: category_path(category)
    end
  end

  context 'with invalid information' do
    before do
      fill_in 'Nazwa', with: ''
      click_button 'Zapisz zmiany'
    end
    it 'should display error message' do
      should have_heading 'Edytuj kategorię'
      should have_error_message
    end
  end

  context 'with valid information' do
    let(:new_name) { 'History' }
    before do
      fill_in 'Nazwa', with: new_name
      click_button 'Zapisz zmiany'
    end

    it 'should display success message' do
      should have_heading new_name
      should have_success_message
    end
  end
end
