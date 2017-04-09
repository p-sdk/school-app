require 'rails_helper'

RSpec.describe 'UsersController authorization', type: :request do
  subject { response }
  let(:user) { create :user }
  let(:admin) { create :admin }

  describe 'GET #index' do
    let(:path) { users_path }
    context 'when not signed in' do
      before { get path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as non-admin user' do
        before do
          sign_in_as user
          get path
        end
        it { should redirect_to root_path }
      end

      context 'as admin' do
        before do
          sign_in_as admin
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

  describe 'GET #new' do
    let(:path) { new_user_path }
    context 'when not signed in' do
      before { get path }
      it { should be_success }
    end

    context 'when signed in' do
      before do
        sign_in_as user
        get path
      end
      it { should redirect_to root_path }
    end
  end

  describe 'GET #edit' do
    let(:path) { edit_user_path(user) }
    context 'when not signed in' do
      before { get path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as correct user' do
        before do
          sign_in_as user
          get path
        end
        it { should be_success }
      end

      context 'as other user' do
        before do
          sign_in_as create :user
          get path
        end
        it { should redirect_to root_path }
      end
    end
  end

  describe 'POST #create' do
    let(:path) { users_path }
    let(:params) { { user: user.attributes } }
    context 'when not signed in' do
      before { post path, params }
      it { should_not redirect_to root_path }
    end

    context 'when signed in' do
      before do
        sign_in_as user
        post path, params
      end
      it { should redirect_to root_path }
    end
  end

  describe 'PATCH #update' do
    let(:path) { user_path(user) }
    let(:params) { { user: user.attributes } }
    context 'when not signed in' do
      before { patch path, params }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as correct user' do
        before do
          sign_in_as user
          patch path, params
        end
        it { should_not redirect_to root_path }
      end

      context 'as other user' do
        before do
          sign_in_as create :user
          patch path, params
        end
        it { should redirect_to root_path }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:path) { user_path(user) }
    context 'when not signed in' do
      before { delete path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as correct user' do
        before do
          sign_in_as user
          delete path
        end
        it { should_not redirect_to root_path }
      end

      context 'as other user' do
        before do
          sign_in_as create :user
          delete path
        end
        it { should redirect_to root_path }
      end
    end
  end
end
