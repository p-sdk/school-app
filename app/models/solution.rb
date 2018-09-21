# == Schema Information
#
# Table name: solutions
#
#  id            :integer          not null, primary key
#  enrollment_id :integer          not null
#  task_id       :integer          not null
#  content       :text
#  earned_points :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_solutions_on_enrollment_id              (enrollment_id)
#  index_solutions_on_enrollment_id_and_task_id  (enrollment_id,task_id) UNIQUE
#  index_solutions_on_task_id                    (task_id)
#
# Foreign Keys
#
#  fk_rails_8f3c6a6975  (task_id => tasks.id)
#  fk_rails_da0ffd369c  (enrollment_id => enrollments.id)
#

class Solution < ApplicationRecord
  belongs_to :enrollment
  belongs_to :task
  delegate :student, to: :enrollment

  scope :graded, -> { where.not(earned_points: nil) }
  scope :ungraded, -> { where(earned_points: nil) }
  scope :for_student, ->(student) { where(enrollment: student&.enrollments) }

  validates :content,
            presence: true,
            length: { maximum: 100_000 }

  validates :earned_points,
            on: :update,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: ->(s) { s.task.points },
              only_integer: true
            }

  validate :check_course

  def graded?
    !earned_points.nil?
  end

  private

  def check_course
    return if enrollment&.course == task&.course
    errors[:base] << I18n.t('errors.messages.record_invalid')
  end
end
