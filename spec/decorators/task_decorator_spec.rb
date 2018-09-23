require 'spec_helper'

RSpec.describe TaskDecorator do
  let(:task) { build(:task).decorate }
  let(:course) { task.course }
  let(:enrollment) { create(:enrollment, course: course) }
  let(:student) { enrollment.student }
  let(:teacher) { course.teacher }

  describe '#average_score' do
    subject { task.average_score }

    context 'when nobody solved the task' do
      it { is_expected.to eq '---' }
    end

    context 'when some students solved the task' do
      let(:enrollments) { create_list :enrollment, 5, course: course }
      let!(:solutions) do
        enrollments.map { |e| create :solution, task: task, enrollment: e }
      end

      context 'when no task has been graded' do
        it { is_expected.to eq '---' }
      end

      context 'when some task has been graded' do
        let(:points) { [20, 7, 12] }
        let(:avg) { points.sum / points.size }

        before do
          points.each_with_index do |pt, i|
            solutions[i].update! earned_points: pt
          end
        end

        it { is_expected.to eq avg }
      end
    end
  end

  describe '#description_formatted' do
    subject { task.description_formatted }

    before do
      task.desc = '# Header'
    end

    it { is_expected.to eq "<h1>Header</h1>\n" }
  end

  describe '#status_for' do
    let(:user) { student }
    let(:solutions) { Solution.none }
    subject { task.status_for(user, solutions) }

    context 'when user is a course teacher' do
      let(:user) { teacher }
      it { is_expected.to be_nil }
    end

    context 'when task has not been solved' do
      it { is_expected.to eq '<span class="task-status unsolved">nierozwiązane</span>' }
    end

    context 'when task has been solved and waits for review' do
      let(:solutions) { create_list :solution, 1, enrollment: enrollment, task: task }

      it { is_expected.to eq '<span class="task-status ungraded">czeka na sprawdzenie</span>' }
    end

    context 'when task has been solved and graded' do
      let(:solutions) { create_list :solution, 1, enrollment: enrollment, task: task, earned_points: 10 }

      it { is_expected.to eq '<span class="task-status graded">ocenione</span>' }
    end
  end
end
