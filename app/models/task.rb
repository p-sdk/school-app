# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  title      :string
#  desc       :text
#  points     :integer
#  course_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tasks_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_d35d17a7dd  (course_id => courses.id)
#

class Task < ActiveRecord::Base
  belongs_to :course, required: true
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

  private

  def enrollment(student)
    student.enrollments.find_by(course: course)
  end
end
