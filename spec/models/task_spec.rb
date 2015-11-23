# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  title      :string
#  desc       :text
#  points     :integer
#  course_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tasks_on_course_id  (course_id)
#

require 'rails_helper'

RSpec.describe Task, type: :model do
  subject(:task) { create :task }
  let(:course) { task.course }
  let(:student) { create :user }
  let(:enrollment) { student.enroll_in course }

  describe 'validations' do
    it { should belong_to(:course) }
    it { should validate_presence_of(:course) }

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(100) }

    it { should validate_presence_of(:desc) }
    it { should validate_length_of(:desc).is_at_most(100_000) }

    it { should validate_presence_of(:points) }
    it { should validate_numericality_of(:points).is_greater_than(0) }

    it { should have_many(:solutions) }
  end

  describe '#solve' do
    before { enrollment }

    context 'with invalid content' do
      specify { expect(task.solve content: '', student: student).to be_falsey }
    end

    context 'with invalid student' do
      specify do
        expect(task.solve content: 'Lorem', student: create(:user)).to be_falsey
      end
    end

    context 'with valid arguments' do
      specify do
        expect(task.solve content: 'Lorem', student: student).to be_truthy
      end
    end
  end

  describe '#solution_by' do
    context 'when task has not been solved' do
      specify { expect(task.solution_by student).to be nil }
    end

    context 'when task has been solved' do
      let!(:solution) { create :solution, enrollment: enrollment, task: task }
      specify { expect(task.solution_by student).to eq solution }
    end
  end

  describe '#solved_by?' do
    context 'when student has not solved the task' do
      it { should_not be_solved_by student }
    end

    context 'when student has solved the task' do
      before { create :solution, enrollment: enrollment, task: task }
      it { should be_solved_by student }
    end
  end

  describe '#graded_for?' do
    let(:solution) { create :solution, enrollment: enrollment, task: task }

    context 'when task has not been garded' do
      it { should_not be_graded_for student }
    end

    context 'when task has been garded' do
      before { solution.update! earned_points: 10 }
      it { should be_graded_for student }
    end
  end

  describe '#status_for' do
    context 'when task has not been solved' do
      specify { expect(task.status_for student).to eq 'nierozwiązane' }
    end

    context 'when task has been solved and waits for review' do
      before { create :solution, enrollment: enrollment, task: task }
      specify { expect(task.status_for student).to eq 'czeka na sprawdzenie' }
    end

    context 'when task has been solved and graded' do
      let(:solution) { create :solution, enrollment: enrollment, task: task }
      before { solution.update! earned_points: 10 }
      specify { expect(task.status_for student).to eq 'ocenione' }
    end
  end

  describe '#earned_points_by' do
    context 'when task has not been solved' do
      specify { expect(task.earned_points_by student).to be nil }
    end

    context 'when task has been solved and waits for review' do
      before { create :solution, enrollment: enrollment, task: task }
      specify { expect(task.earned_points_by student).to be nil }
    end

    context 'when task has been solved and graded' do
      let(:solution) { create :solution, enrollment: enrollment, task: task }
      before { solution.update! earned_points: 10 }
      specify { expect(task.earned_points_by student).to eq solution.earned_points }
    end
  end

  describe '#avg_score' do
    context 'when nobody solved the task' do
      specify { expect(task.avg_score).to be nil }
    end

    context 'when some students solved the task' do
      let(:enrollments) { create_list :enrollment, 5, course: task.course }
      let!(:solutions) do
        enrollments.map { |e| create :solution, task: task, enrollment: e }
      end

      context 'when no task has been graded' do
        specify { expect(task.avg_score).to be nil }
      end

      context 'when some task has been graded' do
        let(:points) { [20, 7, 12] }
        let(:avg) { points.sum / points.size }
        before do
          points.each_with_index do |pt, i|
            solutions[i].update! earned_points: pt
          end
        end

        specify { expect(task.avg_score).to eq avg }
      end
    end
  end

  describe '#enrollment' do
    before { enrollment }
    specify { expect(task.send :enrollment, student).to eq enrollment }
  end
end
