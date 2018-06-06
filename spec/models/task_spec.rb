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
# Foreign Keys
#
#  fk_rails_d35d17a7dd  (course_id => courses.id)
#

require 'rails_helper'

RSpec.describe Task, type: :model do
  subject(:task) { build :task }
  let(:student) { create :student, course: task.course }
  let(:solution) { create :solution, enrollment: student.enrollments.first, task: task }

  describe 'validations' do
    it { should belong_to(:course) }

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(100) }

    it { should validate_presence_of(:desc) }
    it { should validate_length_of(:desc).is_at_most(100_000) }

    it { should validate_presence_of(:points) }
    it { should validate_numericality_of(:points).is_greater_than(0) }

    it { should have_many(:solutions).dependent(:destroy) }
  end

  describe '#solution_by' do
    context 'when task has not been solved' do
      specify { expect(task.solution_by student).to be nil }
    end

    context 'when task has been solved' do
      before { solution }
      specify { expect(task.solution_by student).to eq solution }
    end
  end

  describe '#solved_by?' do
    context 'when student has not solved the task' do
      it { should_not be_solved_by student }
    end

    context 'when student has solved the task' do
      before { solution }
      it { should be_solved_by student }
    end
  end

  describe '#graded_for?' do
    context 'when task has not been garded' do
      it { should_not be_graded_for student }
    end

    context 'when task has been garded' do
      before { solution.update! earned_points: 10 }
      it { should be_graded_for student }
    end
  end

  describe '#earned_points_by' do
    context 'when task has not been solved' do
      specify { expect(task.earned_points_by student).to be nil }
    end

    context 'when task has been solved and waits for review' do
      before { solution }
      specify { expect(task.earned_points_by student).to be nil }
    end

    context 'when task has been solved and graded' do
      before { solution.update! earned_points: 10 }
      specify { expect(task.earned_points_by student).to eq solution.earned_points }
    end
  end
end
