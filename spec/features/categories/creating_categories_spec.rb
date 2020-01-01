require 'rails_helper'

RSpec.feature 'Admin creates a category' do
  subject { page }

  let(:admin) { create :admin }
  let(:category_attributes) { attributes_for :category }
  let(:name) { category_attributes[:name] }

  background do
    sign_in admin
    visit categories_path
    click_link 'Dodaj nową kategorię'
  end

  scenario 'with invalid attributes' do
    should have_heading 'Utwórz nową kategorię'
    should have_link 'Kategorie', href: categories_path

    expect { click_button 'Utwórz kategorię' }.not_to change(Category, :count)

    should have_heading 'Utwórz nową kategorię'
    should have_error_message
  end

  scenario 'with valid attributes' do
    fill_in 'Nazwa', with: name

    expect { click_button 'Utwórz kategorię' }.to change(Category, :count).by(1)

    should have_heading name
    should have_success_message
  end
end
