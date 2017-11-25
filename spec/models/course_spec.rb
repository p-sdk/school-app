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
# Foreign Keys
#
#  fk_rails_a68eff6aff  (teacher_id => users.id)
#  fk_rails_e072dca946  (category_id => categories.id)
#

require 'rails_helper'

RSpec.describe Course, type: :model do
  subject(:course) { build :course }

  describe 'validations' do
    it { should belong_to(:category) }
    it { should validate_presence_of(:category) }

    it { should belong_to(:teacher).class_name('User') }
    it { should validate_presence_of(:teacher) }

    it { should have_many(:enrollments).dependent(:destroy) }
    it { should have_many(:students).through(:enrollments) }
    it { should have_many(:lectures).dependent(:destroy) }
    it { should have_many(:tasks).dependent(:destroy) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name). is_at_least(3). is_at_most(200) }

    it { should validate_length_of(:desc). is_at_most(100_000) }
  end

  describe '#has_student?' do
    let(:student) { build :user }

    context 'when student has not enrolled in the course' do
      specify { expect(course.has_student? student).to be false }
    end

    context 'when student has enrolled in the course' do
      before { create :enrollment, student: student, course: course }

      specify { expect(course.has_student? student).to be true }
    end
  end
end
