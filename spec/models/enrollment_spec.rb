# == Schema Information
#
# Table name: enrollments
#
#  id         :integer          not null, primary key
#  student_id :integer          not null
#  course_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_enrollments_on_course_id                 (course_id)
#  index_enrollments_on_student_id                (student_id)
#  index_enrollments_on_student_id_and_course_id  (student_id,course_id) UNIQUE
#

require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  let(:student) { create :user }
  let(:course) { create :course }
  subject(:enrollment) { student.enrollments.create!(course: course) }

  specify { expect(enrollment.student).to eq student }
  specify { expect(enrollment.course).to eq course }

  describe '[student, course] uniqueness' do
    let(:second_enrollment) { student.enrollments.build(course: course) }
    before { enrollment }
    specify do
      expect { second_enrollment.save }.to raise_error ActiveRecord::RecordNotUnique
    end
  end

  describe 'validations' do
    it { should belong_to(:student).class_name('User') }
    it { should validate_presence_of(:student) }

    it { should belong_to(:course) }
    it { should validate_presence_of(:course) }

    it { should have_many(:solutions).dependent(:destroy) }
  end
end
