require 'rails_helper'

RSpec.feature 'Admin deletes a category', type: :feature do
  subject { page }

  let(:admin) { create :admin }
  let(:category) { create :category }

  background do
    sign_in admin
    visit category_path(category)
  end

  scenario 'successfully' do
    expect { click_link 'Usuń' }.to change(Category, :count).by(-1)

    expect(current_path).to eq categories_path
    should have_success_message
  end
end
