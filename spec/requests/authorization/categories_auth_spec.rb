require 'rails_helper'

RSpec.describe 'CategoriesController authorization', type: :request do
  subject { response }
  let(:user) { create :user }
  let(:admin) { create :admin }
  let(:category) { create :category }

  describe 'GET #index' do
    let(:path) { categories_path }
    before { get path }
    it { should be_success }
  end

  describe 'GET #show' do
    let(:path) { category_path(category) }
    before { get path }
    it { should be_success }
  end

  describe 'GET #new' do
    let(:path) { new_category_path }
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

  describe 'GET #edit' do
    let(:path) { edit_category_path(category) }
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

  describe 'POST #create' do
    let(:path) { categories_path }
    let(:params) { { category: category.attributes } }
    context 'when not signed in' do
      before { post path, params }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as non-admin user' do
        before do
          sign_in_as user
          post path, params
        end
        it { should redirect_to root_path }
      end

      context 'as admin' do
        before do
          sign_in_as admin
          post path, params
        end
        it { should_not redirect_to root_path }
      end
    end
  end

  describe 'PATCH #update' do
    let(:path) { category_path(category) }
    let(:params) { { category: category.attributes } }
    context 'when not signed in' do
      before { patch path, params }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as non-admin user' do
        before do
          sign_in_as user
          patch path, params
        end
        it { should redirect_to root_path }
      end

      context 'as admin' do
        before do
          sign_in_as admin
          patch path, params
        end
        it { should_not redirect_to root_path }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:path) { category_path(category) }
    context 'when not signed in' do
      before { delete path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as admin' do
        before do
          sign_in_as admin
          delete path
        end
        it { should_not redirect_to root_path }
      end

      context 'as non-admin user' do
        before do
          sign_in_as user
          delete path
        end
        it { should redirect_to root_path }
      end
    end
  end
end
