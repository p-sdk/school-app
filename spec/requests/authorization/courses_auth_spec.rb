require 'rails_helper'

RSpec.describe 'CoursesController authorization', type: :request do
  subject { response }
  let(:course) { create :course }
  let(:teacher) { course.teacher }
  let(:other_teacher){ create :teacher }
  let(:student) { create :user }

  describe 'GET #index' do
    let(:path) { courses_path }
    before { get path }
    it { should be_success }
  end

  describe 'GET #show' do
    let(:path) { course_path(course) }
    before { get path }
    it { should be_success }
  end

  describe 'GET #new' do
    let(:path) { new_course_path }
    context 'when not signed in' do
      before { get path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as teacher' do
        before do
          sign_in_as teacher
          get path
        end
        it { should be_success }
      end

      context 'as student' do
        before do
          sign_in_as student
          get path
        end
        it { should redirect_to root_path }
      end
    end
  end

  describe 'GET #edit' do
    let(:path) { edit_course_path(course) }
    context 'when not signed in' do
      before { get path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as course teacher' do
        before do
          sign_in_as teacher
          get path
        end
        it { should be_success }
      end

      context 'as other teacher' do
        before do
          sign_in_as other_teacher
          get path
        end
        it { should redirect_to root_path }
      end

      context 'as student' do
        before do
          sign_in_as student
          get path
        end
        it { should redirect_to root_path }
      end
    end
  end

  describe 'POST #create' do
    let(:path) { courses_path }
    let(:params) { { course: course.attributes } }
    context 'when not signed in' do
      before { post path, params }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as teacher' do
        before do
          sign_in_as teacher
          post path, params
        end
        it { should_not redirect_to root_path }
      end

      context 'as student' do
        before do
          sign_in_as student
          post path, params
        end
        it { should redirect_to root_path }
      end
    end
  end

  describe 'PATCH #update' do
    let(:path) { course_path(course) }
    let(:params) { { course: course.attributes } }
    context 'when not signed in' do
      before { patch path, params }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as course teacher' do
        before do
          sign_in_as teacher
          patch path, params
        end
        it { should_not redirect_to root_path }
      end

      context 'as other teacher' do
        before do
          sign_in_as other_teacher
          patch path, params
        end
        it { should redirect_to root_path }
      end

      context 'as student' do
        before do
          sign_in_as student
          patch path, params
        end
        it { should redirect_to root_path }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:path) { course_path(course) }
    context 'when not signed in' do
      before { delete path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as course teacher' do
        before do
          sign_in_as teacher
          delete path
        end
        it { should_not redirect_to root_path }
      end

      context 'as other teacher' do
        before do
          sign_in_as other_teacher
          delete path
        end
        it { should redirect_to root_path }
      end

      context 'as student' do
        before do
          sign_in_as student
          delete path
        end
        it { should redirect_to root_path }
      end
    end
  end

  describe 'GET #students' do
    let(:path) { students_course_path(course) }
    context 'when not signed in' do
      before { get path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as course teacher' do
        before do
          sign_in_as teacher
          get path
        end
        it { should_not redirect_to root_path }
      end

      context 'as other teacher' do
        before do
          sign_in_as other_teacher
          get path
        end
        it { should redirect_to root_path }
      end

      context 'as student' do
        before do
          sign_in_as student
          get path
        end
        it { should redirect_to root_path }
      end
    end
  end
end
