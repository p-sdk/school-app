require 'rails_helper'

RSpec.describe 'SolutionsController authorization', type: :request do
  subject { response }
  let(:solution) { create :solution }
  let(:course) { solution.task.course }
  let(:teacher) { course.teacher }
  let(:other_teacher) { create :teacher }
  let(:student) { solution.enrollment.student }
  let(:other_student) { create :user }

  describe 'GET #show' do
    let(:path) { solution_path(solution) }
    context 'when not signed in' do
      before { get path }
      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      context 'as student' do
        context 'who created the solution' do
          before do
            login_as student
            get path
          end
          it { should be_success }
        end

        context 'enrolled in the course' do
          before do
            other_student.enroll_in course
            login_as other_student
            get path
          end
          it { should redirect_to root_path }
        end

        context '(other)' do
          before do
            login_as other_student
            get path
          end
          it { should redirect_to root_path }
        end
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            login_as teacher
            get path
          end
          it { should be_success }
        end

        context '(other)' do
          before do
            login_as other_teacher
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
      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      context 'as student' do
        before do
          login_as student
          get path
        end
        it { should redirect_to root_path }
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            login_as teacher
            get path
          end
          it { should be_success }
        end

        context '(other)' do
          before do
            login_as other_teacher
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
      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      context 'as student' do
        context 'who already created the solution' do
          before do
            login_as student
            post path, params
          end
          it { should redirect_to root_path }
        end

        context 'enrolled in the course' do
          before do
            other_student.enroll_in course
            login_as other_student
            post path, params
          end
          it { should_not redirect_to root_path }
        end

        context '(other)' do
          before do
            login_as other_student
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
      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      context 'as student' do
        before do
          login_as student
          patch path, params
        end
        it { should redirect_to root_path }
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            login_as teacher
            patch path, params
          end
          it { should_not redirect_to root_path }
        end

        context '(other)' do
          before do
            login_as other_teacher
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
      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      context 'as student' do
        before do
          login_as student
          delete path
        end
        it { should redirect_to root_path }
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            login_as teacher
            delete path
          end
          it { should_not redirect_to root_path }
        end

        context '(other)' do
          before do
            login_as other_teacher
            delete path
          end
          it { should redirect_to root_path }
        end
      end
    end
  end
end
