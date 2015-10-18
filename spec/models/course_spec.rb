# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  name        :string
#  desc        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  teacher_id  :integer
#  category_id :integer
#
# Indexes
#
#  index_courses_on_category_id  (category_id)
#  index_courses_on_teacher_id   (teacher_id)
#

require 'rails_helper'

RSpec.describe Course, type: :model do
  subject(:course) { create :course }
  let(:student) { create :user }
  let(:enrollment) { student.enroll_in course }

  describe 'validations' do
    it { should belong_to(:category) }
    it { should validate_presence_of(:category) }

    it { should belong_to(:teacher).class_name('User') }
    it { should validate_presence_of(:teacher) }

    it { should have_many(:enrollments) }
    it { should have_many(:students).through(:enrollments).source(:student) }
    it { should have_many(:lectures) }
    it { should have_many(:tasks) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name). is_at_least(3). is_at_most(200) }

    it { should validate_length_of(:desc). is_at_most(100_000) }
  end

  describe '#has_student?' do
    context 'when student has not enrolled in the course' do
      specify { expect(course.has_student? student).to be false }
    end

    context 'when student has enrolled in the course' do
      before { student.enroll_in course }
      specify { expect(course.has_student? student).to be true }
    end
  end

  describe '#points' do
    context 'when there is no task' do
      specify { expect(course.points).to eq 0 }
    end

    context 'when there are some tasks' do
      let(:task_points) { [20, 30, 70] }
      let(:correct_points) { task_points.sum }
      before do
        task_points.each { |points| create :task, course: course, points: points }
      end

      specify { expect(course.points).to eq correct_points }
    end
  end

  describe '#earned_points_by' do
    context 'when no task has been solved' do
      specify { expect(course.earned_points_by student).to eq 0 }
    end

    context 'when some tasks has been solved and graded' do
      let(:task_earned_points) { [10, 25, 17] }
      let(:correct_earned_points) { task_earned_points.sum }
      before do
        task_earned_points.each do |points|
          task = create :task, course: course
          solution = create :solution, enrollment: enrollment, task: task
          solution.update! earned_points: points
        end
      end

      specify { expect(course.earned_points_by student).to eq correct_earned_points }
    end
  end
end
