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

class Enrollment < ApplicationRecord
  belongs_to :student, class_name: 'User'
  belongs_to :course

  has_many :solutions, dependent: :destroy

  validates_uniqueness_of :student_id, scope: :course_id
end
