require 'rails_helper'

RSpec.describe 'LecturesController authorization', type: :request do
  subject { response }
  let(:student) { create :user }
  let(:teacher) { create :teacher }
  let(:course) { create :course, teacher: teacher }
  let(:lecture) { create :lecture, course: course }
  before { student.enroll_in course }

  describe 'GET #index' do
    let(:path) { course_lectures_path(course) }
    context 'when not singed in' do
      before { get path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as student' do
        context 'enrolled in the course' do
          before do
            sign_in_as student
            get path
          end
          it { should be_success }
        end

        context 'not enrolled in the course' do
          before do
            sign_in_as create :user
            get path
          end
          it { should redirect_to root_path }
        end
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            sign_in_as teacher
            get path
          end
          it { should be_success }
        end

        context '(other)' do
          before do
            sign_in_as create :teacher
            get path
          end
          it { should redirect_to root_path }
        end
      end
    end
  end

  describe 'GET #show' do
    let(:path) { course_lecture_path(course, lecture) }
    context 'when not singed in' do
      before { get path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as student' do
        context 'enrolled in the course' do
          before do
            sign_in_as student
            get path
          end
          it { should be_success }
        end

        context 'not enrolled in the course' do
          before do
            sign_in_as create :user
            get path
          end
          it { should redirect_to root_path }
        end
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            sign_in_as teacher
            get path
          end
          it { should be_success }
        end

        context '(other)' do
          before do
            sign_in_as create :teacher
            get path
          end
          it { should redirect_to root_path }
        end
      end
    end
  end

  describe 'GET #new' do
    let(:path) { new_course_lecture_path(course) }
    context 'when not singed in' do
      before { get path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as student' do
        before do
          sign_in_as student
          get path
        end
        it { should redirect_to root_path }
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            sign_in_as teacher
            get path
          end
          it { should be_success }
        end

        context '(other)' do
          before do
            sign_in_as create :teacher
            get path
          end
          it { should redirect_to root_path }
        end
      end
    end
  end

  describe 'GET #edit' do
    let(:path) { edit_course_lecture_path(course, lecture) }
    context 'when not singed in' do
      before { get path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as student' do
        before do
          sign_in_as student
          get path
        end
        it { should redirect_to root_path }
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            sign_in_as teacher
            get path
          end
          it { should be_success }
        end

        context '(other)' do
          before do
            sign_in_as create :teacher
            get path
          end
          it { should redirect_to root_path }
        end
      end
    end
  end

  describe 'POST #create' do
    let(:path) { course_lectures_path(course) }
    let(:params) { { lecture: lecture.attributes } }
    context 'when not singed in' do
      before { post path, params }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as student' do
        before do
          sign_in_as student
          post path, params
        end
        it { should redirect_to root_path }
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            sign_in_as teacher
            post path, params
          end
          it { should_not redirect_to root_path }
        end

        context '(other)' do
          before do
            sign_in_as create :teacher
            post path, params
          end
          it { should redirect_to root_path }
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:path) { course_lecture_path(course, lecture) }
    let(:params) { { lecture: lecture.attributes } }
    context 'when not singed in' do
      before { patch path, params }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as student' do
        before do
          sign_in_as student
          patch path, params
        end
        it { should redirect_to root_path }
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            sign_in_as teacher
            patch path, params
          end
          it { should_not redirect_to root_path }
        end

        context '(other)' do
          before do
            sign_in_as create :teacher
            patch path, params
          end
          it { should redirect_to root_path }
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:path) { course_lecture_path(course, lecture) }
    context 'when not singed in' do
      before { delete path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as student' do
        before do
          sign_in_as student
          delete path
        end
        it { should redirect_to root_path }
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            sign_in_as teacher
            delete path
          end
          it { should_not redirect_to root_path }
        end

        context '(other)' do
          before do
            sign_in_as create :teacher
            delete path
          end
          it { should redirect_to root_path }
        end
      end
    end
  end
end
