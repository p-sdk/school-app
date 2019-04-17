# == Schema Information
#
# Table name: solutions
#
#  id            :integer          not null, primary key
#  enrollment_id :integer          not null
#  task_id       :integer          not null
#  content       :text
#  earned_points :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_solutions_on_enrollment_id              (enrollment_id)
#  index_solutions_on_enrollment_id_and_task_id  (enrollment_id,task_id) UNIQUE
#  index_solutions_on_task_id                    (task_id)
#
# Foreign Keys
#
#  fk_rails_...  (enrollment_id => enrollments.id)
#  fk_rails_...  (task_id => tasks.id)
#

require 'rails_helper'

RSpec.describe Solution, type: :model do
  subject(:solution) { build :solution }
  let(:enrollment) { solution.enrollment }
  let(:task) { solution.task }

  describe '[enrollment, task] uniqueness' do
    let!(:second_solution) { create :solution, task: task, enrollment: enrollment }
    specify do
      expect { solution.save }.to raise_error ActiveRecord::RecordNotUnique
    end
  end

  describe 'validations' do
    it { should belong_to(:enrollment) }

    it { should belong_to(:task) }

    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(100_000) }

    it do
      should validate_numericality_of(:earned_points)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(task.points)
        .on :update
    end

    describe 'enrollment and task belong to the same course' do
      specify { expect(solution.enrollment.course).to eq solution.task.course }
      it { should be_valid }

      context 'with other task' do
        let(:other_task) { build :task }
        before { solution.task = other_task }
        it { should_not be_valid }
      end

      context 'with other enrollment' do
        let(:other_enrollment) { build :enrollment }
        before { solution.enrollment = other_enrollment }
        it { should_not be_valid }
      end
    end
  end

  describe '.graded' do
    subject { described_class.graded }

    let!(:graded_solution) { create :graded_solution }
    let!(:not_graded_solution) { create :solution }

    it { is_expected.to include graded_solution }
    it { is_expected.to_not include not_graded_solution }
  end

  describe '.ungraded' do
    subject { described_class.ungraded }

    let!(:graded_solution) { create :graded_solution }
    let!(:not_graded_solution) { create :solution }

    it { is_expected.to include not_graded_solution }
    it { is_expected.to_not include graded_solution }
  end

  describe '#graded?' do
    context 'with unset earned_points' do
      it { should_not be_graded }
    end

    context 'with set earned_points' do
      before { solution.earned_points = 10 }
      it { should be_graded }
    end
  end

  describe '#max_points' do
    specify { expect(solution.max_points).to eq task.points }
  end

  describe '#student' do
    specify { expect(solution.student).to eq enrollment.student }
  end

  describe '#student_name' do
    specify { expect(solution.student_name).to eq solution.student.name }
  end
end
