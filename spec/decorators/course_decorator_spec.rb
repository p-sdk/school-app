require 'spec_helper'

RSpec.describe CourseDecorator do
  let(:course) { build(:course).decorate }
  let(:enrollment) { create(:enrollment, course: course) }
  let(:student) { enrollment.student }

  describe '#description_formatted' do
    subject { course.description_formatted }

    before do
      course.desc = '# Header'
    end

    it { is_expected.to eq "<h1>Header</h1>\n" }
  end

  describe '#points_earned_by' do
    subject { course.points_earned_by(student) }

    context 'when no task has been solved' do
      it { is_expected.to eq 0 }
    end

    context 'when some tasks has been solved and graded' do
      let(:task_earned_points) { [10, 25, 17] }
      let(:total_earned_points) { task_earned_points.sum }

      before do
        task_earned_points.each do |points|
          task = create :task, course: course
          solution = create :solution, enrollment: enrollment, task: task
          solution.update! earned_points: points
        end
        create :task, course: course # unsolved task
      end

      it { is_expected.to eq total_earned_points }
    end
  end

  describe '#total_points' do
    subject { course.total_points }

    context 'when there is no task' do
      it { is_expected.to eq 0 }
    end

    context 'when there are some tasks' do
      let(:task_points) { [20, 30, 70] }
      let(:total_points) { task_points.sum }

      before do
        task_points.each { |points| create :task, course: course, points: points }
      end

      it { is_expected.to eq total_points }
    end
  end
end
