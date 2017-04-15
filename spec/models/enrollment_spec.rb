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
# Foreign Keys
#
#  fk_rails_2e119501f4  (course_id => courses.id)
#  fk_rails_f01c555e06  (student_id => users.id)
#

require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  subject(:enrollment) { build :enrollment }

  describe '[student, course] uniqueness' do
    let(:student) { enrollment.student }
    let(:course) { enrollment.course }
    let!(:second_enrollment) { create :enrollment, student: student, course: course }

    specify do
      expect { enrollment.save }.to raise_error ActiveRecord::RecordNotUnique
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
