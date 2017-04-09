require 'rails_helper'

RSpec.describe 'SolutionsController authorization', type: :request do
  subject { response }
  let(:student) { create :user }
  let(:teacher) { create :teacher }
  let(:course) { create :course, teacher: teacher }
  let(:enrollment) { student.enroll_in course }
  let(:task) { create :task, course: course }
  let(:solution) { create :solution, enrollment: enrollment, task: task }

  describe 'GET #show' do
    let(:path) { solution_path(solution) }
    context 'when not signed in' do
      before { get path }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as student' do
        context 'who created the solution' do
          before do
            sign_in_as student
            get path
          end
          it { should be_success }
        end

        context 'enrolled in the course' do
          before do
            second_student = create :user
            second_student.enroll_in course
            sign_in_as second_student
            get path
          end
          it { should redirect_to root_path }
        end

        context '(other)' do
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

  describe 'GET #edit' do
    let(:path) { edit_solution_path(solution) }
    context 'when not signed in' do
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
    let(:path) { solutions_path }
    let(:params) { { solution: solution.attributes } }
    context 'when not signed in' do
      before { post path, params }
      it { should redirect_to signin_path }
    end

    context 'when signed in' do
      context 'as student' do
        context 'who already created the solution' do
          before do
            sign_in_as student
            post path, params
          end
          it { should redirect_to root_path }
        end

        context 'enrolled in the course' do
          before do
            enrolled_student = create :user
            enrolled_student.enroll_in course
            sign_in_as enrolled_student
            post path, params
          end
          it { should_not redirect_to root_path }
        end

        context '(other)' do
          before do
            sign_in_as create :user
            post path, params
          end
          it { should redirect_to root_path }
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:path) { solution_path(solution) }
    let(:params) { { solution: solution.attributes } }
    context 'when not signed in' do
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
    let(:path) { solution_path(solution) }
    context 'when not signed in' do
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
