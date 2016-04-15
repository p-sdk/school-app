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

class Solution < ActiveRecord::Base
  belongs_to :enrollment, required: true
  belongs_to :task, required: true
  delegate :student, to: :enrollment

  scope :graded, -> { where.not(earned_points: nil) }
  scope :ungraded, -> { where(earned_points: nil) }

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
    errors[:base] << 'This solution is invalid'
  end
end
