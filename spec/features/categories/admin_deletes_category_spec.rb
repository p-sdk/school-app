require 'rails_helper'

RSpec.feature 'Admin deletes a category', type: :feature do
  subject { page }

  let(:admin) { create :admin }
  let(:category) { create :category }

  before do
    sign_in_as admin
    visit category_path(category)
  end

  it 'should delete the category' do
    expect { click_link 'Usuń' }.to change(Category, :count).by(-1)
  end

  context 'after deleting' do
    before { click_link 'Usuń' }
    it 'should display success message' do
      expect(current_path).to eq categories_path
      should have_success_message
    end
  end
end
