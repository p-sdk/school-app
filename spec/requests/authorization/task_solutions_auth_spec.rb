require 'rails_helper'

RSpec.describe 'TaskSolutionsController authorization', type: :request do
  subject { response }
  let(:task) { create :task }
  let(:course) { task.course }
  let(:teacher) { course.teacher }
  let(:other_teacher) { create :teacher }
  let(:student) { u = create :user; u.enroll_in course; u }

  describe 'GET #index' do
    let(:path) { course_task_solutions_path(course, task) }
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
end
