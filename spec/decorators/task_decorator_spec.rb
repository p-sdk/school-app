require 'spec_helper'

RSpec.describe TaskDecorator do
  let(:task) { build(:task).decorate }
  let(:enrollment) { create(:enrollment, course: task.course) }
  let(:student) { enrollment.student }

  describe '#average_score' do
    subject { task.average_score }

    context 'when nobody solved the task' do
      it { is_expected.to eq '---' }
    end

    context 'when some students solved the task' do
      let(:enrollments) { create_list :enrollment, 5, course: task.course }
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
    subject { task.status_for(student) }

    context 'when task has not been solved' do
      it { is_expected.to eq 'nierozwiązane' }
    end

    context 'when task has been solved and waits for review' do
      before { create :solution, enrollment: enrollment, task: task }

      it { is_expected.to eq 'czeka na sprawdzenie' }
    end

    context 'when task has been solved and graded' do
      let(:solution) { create :solution, enrollment: enrollment, task: task }

      before { solution.update! earned_points: 10 }

      it { is_expected.to eq 'ocenione' }
    end
  end
end
