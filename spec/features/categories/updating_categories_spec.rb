require 'rails_helper'

RSpec.feature 'Admin updates a category', type: :feature do
  subject { page }

  let(:admin) { create :admin }
  let(:category) { create :category }
  let(:new_name) { 'History' }

  background do
    sign_in admin
    visit category_path(category)
    click_link 'Edytuj'
  end

  scenario 'with invalid attributes' do
    should have_heading 'Edytuj kategorię'
    should have_link category.name, href: category_path(category)

    fill_in 'Nazwa', with: ''
    click_button 'Zapisz zmiany'

    should have_heading 'Edytuj kategorię'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Nazwa', with: new_name
    click_button 'Zapisz zmiany'

    should have_heading new_name
    should have_success_message
  end
end
