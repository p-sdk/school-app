require 'rails_helper'

RSpec.describe 'TasksController authorization', type: :request do
  subject { response }
  let(:task) { create :task }
  let(:course) { task.course }
  let(:teacher) { course.teacher }
  let(:other_teacher) { create :teacher }
  let(:student) { u = create :user; u.enroll_in course; u }
  let(:other_student) { create :user }

  describe 'GET #index' do
    let(:path) { course_tasks_path(course) }
    context 'when not singed in' do
      before { get path }
      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      context 'as student' do
        context 'enrolled in the course' do
          before do
            login_as student
            get path
          end
          it { should be_success }
        end

        context 'not enrolled in the course' do
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

  describe 'GET #show' do
    let(:path) { course_task_path(course, task) }
    context 'when not singed in' do
      before { get path }
      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      context 'as student' do
        context 'enrolled in the course' do
          before do
            login_as student
            get path
          end
          it { should be_success }
        end

        context 'not enrolled in the course' do
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

  describe 'GET #new' do
    let(:path) { new_course_task_path(course) }
    context 'when not singed in' do
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

  describe 'GET #edit' do
    let(:path) { edit_course_task_path(course, task) }
    context 'when not singed in' do
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
    let(:path) { course_tasks_path(course) }
    let(:params) { { task: task.attributes } }
    context 'when not singed in' do
      before { post path, params }
      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      context 'as student' do
        before do
          login_as student
          post path, params
        end
        it { should redirect_to root_path }
      end

      context 'as teacher' do
        context 'who created the course' do
          before do
            login_as teacher
            post path, params
          end
          it { should_not redirect_to root_path }
        end

        context '(other)' do
          before do
            login_as other_teacher
            post path, params
          end
          it { should redirect_to root_path }
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:path) { course_task_path(course, task) }
    let(:params) { { task: task.attributes } }
    context 'when not singed in' do
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
    let(:path) { course_task_path(course, task) }
    context 'when not singed in' do
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
