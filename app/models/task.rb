# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  desc       :text
#  points     :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :integer          not null
#
# Indexes
#
#  index_tasks_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#

class Task < ApplicationRecord
  belongs_to :course
  has_many :solutions, dependent: :destroy

  validates :title,
            presence: true,
            length: { in: 3..100 }

  validates :desc,
            presence: true,
            length: { maximum: 100_000 }

  validates :points,
            presence: true,
            numericality: { greater_than: 0, only_integer: true }

  def solution_by(student)
    solutions.find_by enrollment: enrollment(student)
  end

  def solved_by?(student)
    solution_by(student).present?
  end

  def graded_for?(student)
    solution_by(student)&.graded?
  end

  def earned_points_by(student)
    solution_by(student)&.earned_points
  end

  def to_param
    "#{id}-#{title}".parameterize
  end

  private

  def enrollment(student)
    student.enrollments.find_by(course: course)
  end
end
