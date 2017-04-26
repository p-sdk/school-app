require 'rails_helper'

RSpec.describe 'StudentsController authorization', type: :request do
  subject { response }
  let(:course) { create :course }
  let(:teacher) { course.teacher }
  let(:other_teacher){ create :teacher }
  let(:student) { create :user }


  describe 'GET #index' do
    let(:path) { course_students_path(course) }
    context 'when not signed in' do
      before { get path }
      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      context 'as course teacher' do
        before do
          login_as teacher
          get path
        end
        it { should_not redirect_to root_path }
      end

      context 'as other teacher' do
        before do
          login_as other_teacher
          get path
        end
        it { should redirect_to root_path }
      end

      context 'as student' do
        before do
          login_as student
          get path
        end
        it { should redirect_to root_path }
      end
    end
  end
end
