require 'rails_helper'

RSpec.describe 'EnrollmentsController authorization', type: :request do
  subject { response }
  let(:user) { create :user }
  let(:enrollment) { build :enrollment }

  describe 'POST #create' do
    let(:path) { enrollments_path }
    let(:params) { { enrollment: enrollment.attributes } }
    context 'when not singed in' do
      before { post path, params }
      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      before do
        login_as user
        post path, params
      end
      it { should_not redirect_to new_user_session_path }
    end
  end
end
