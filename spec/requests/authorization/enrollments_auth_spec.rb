require 'rails_helper'

RSpec.describe 'EnrollmentsController authorization', type: :request do
  subject { response }
  let(:user) { create :user }
  let(:enrollment) { create :enrollment }

  describe 'POST #create' do
    let(:path) { enrollments_path }
    let(:params) { { enrollment: enrollment.attributes } }
    context 'when not singed in' do
      before { post path, params }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      before do
        sign_in_as user
        post path, params
      end
      it { should_not redirect_to signin_path }
    end
  end
end
