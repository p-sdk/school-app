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
#  fk_rails_8f3c6a6975  (task_id => tasks.id)
#  fk_rails_da0ffd369c  (enrollment_id => enrollments.id)
#

require 'rails_helper'

RSpec.describe Solution, type: :model do
  let(:course) { create :course }
  let(:task) { create :task, course: course }
  let(:enrollment) { create :enrollment, course: course }
  subject(:solution) { task.solutions.create!(enrollment: enrollment, content: 'Lorem ipsum') }

  specify { expect(solution.enrollment).to eq enrollment }
  specify { expect(solution.task).to eq task }

  describe '[enrollment, task] uniqueness' do
    let(:second_solution) { task.solutions.build(enrollment: enrollment, content: 'Ipsum lorem') }
    before { solution }
    specify do
      expect { second_solution.save }.to raise_error ActiveRecord::RecordNotUnique
    end
  end

  describe 'validations' do
    it { should belong_to(:enrollment) }
    it { should validate_presence_of(:enrollment) }

    it { should belong_to(:task) }
    it { should validate_presence_of(:task) }

    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(100_000) }

    it do
      should validate_numericality_of(:earned_points)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(task.points)
        .on :update
    end

    describe 'enrollment and task belong to the same course' do
      subject(:solution) { build :solution, enrollment: enrollment, task: task }
      specify { expect(solution.enrollment.course).to eq solution.task.course }
      it { should be_valid }

      context 'with other task' do
        let(:other_task) { create :task }
        before { solution.task = other_task }
        it { should_not be_valid }
      end

      context 'with other enrollment' do
        let(:other_enrollment) { create :enrollment }
        before { solution.enrollment = other_enrollment }
        it { should_not be_valid }
      end
    end
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

  describe '#student' do
    specify { expect(solution.student).to eq solution.enrollment.student }
  end
end
