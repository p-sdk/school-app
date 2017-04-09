require 'rails_helper'

RSpec.feature 'User deletes the account', type: :feature do
  subject { page }

  let(:user) { create :user }

  before do
    sign_in_as user
    visit edit_user_path(user)
  end

  it 'should delete the user' do
    expect { click_link 'Usuń' }.to change(User, :count).by(-1)
  end

  context 'after deleting' do
    before { click_link 'Usuń' }
    it 'should display success message' do
      expect(current_path).to eq signup_path
      should have_success_message
    end
  end
end
