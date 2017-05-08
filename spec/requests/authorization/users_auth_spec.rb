require 'rails_helper'

RSpec.describe 'UsersController authorization', type: :request do
  subject { response }
  let(:user) { create :user }
  let(:admin) { create :admin }

  describe 'GET #index' do
    let(:path) { users_path }
    context 'when not signed in' do
      before { get path }
      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      context 'as non-admin user' do
        before do
          login_as user
          get path
        end
        it { should redirect_to root_path }
      end

      context 'as admin' do
        before do
          login_as admin
          get path
        end
        it { should be_success }
      end
    end
  end

  describe 'GET #show' do
    let(:path) { user_path(user) }
    before { get path }
    it { should be_success }
  end
end
