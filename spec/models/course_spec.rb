# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  desc        :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#  teacher_id  :integer
#
# Indexes
#
#  index_courses_on_category_id  (category_id)
#  index_courses_on_teacher_id   (teacher_id)
#

require 'rails_helper'

RSpec.describe Course do
  subject(:course) { build :course }

  describe 'validations' do
    it { should belong_to(:category) }

    it { should belong_to(:teacher).class_name('User') }

    it { should have_many(:enrollments).dependent(:destroy) }
    it { should have_many(:students).through(:enrollments) }
    it { should have_many(:lectures).dependent(:destroy) }
    it { should have_many(:tasks).dependent(:destroy) }
    it { should have_many(:solutions).through(:tasks) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name). is_at_least(3). is_at_most(200) }

    it { should validate_length_of(:desc). is_at_most(100_000) }
  end

  describe '#studied_by?' do
    let(:student) { build :user }

    context 'when student has not enrolled in the course' do
      specify { expect(course.studied_by?(student)).to be false }
    end

    context 'when student has enrolled in the course' do
      before { create :enrollment, student: student, course: course }

      specify { expect(course.studied_by?(student)).to be true }
    end
  end
end
