# == Schema Information
#
# Table name: enrollments
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :integer          not null
#  student_id :integer          not null
#
# Indexes
#
#  index_enrollments_on_course_id                 (course_id)
#  index_enrollments_on_student_id                (student_id)
#  index_enrollments_on_student_id_and_course_id  (student_id,course_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (student_id => users.id)
#

class Enrollment < ApplicationRecord
  belongs_to :student, class_name: 'User'
  belongs_to :course

  has_many :solutions, dependent: :destroy

  validates_uniqueness_of :student_id, scope: :course_id
end
