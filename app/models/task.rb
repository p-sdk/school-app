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

class Task < ActiveRecord::Base
  belongs_to :course, required: true
  has_many :solutions

  validates :title,
            presence: true,
            length: { in: 3..100 }

  validates :desc,
            presence: true,
            length: { maximum: 100_000 }

  validates :points,
            presence: true,
            numericality: { greater_than: 0, only_integer: true }

  def solve(content:, student:)
    return unless can_be_solved_by? student
    s = solutions.build content: content, enrollment: enrollment(student)
    s.save
  end

  def solution_by(student)
    solutions.find_by enrollment: enrollment(student)
  end

  def solved_by?(student)
    solution_by(student).present?
  end

  def can_be_solved_by?(student)
    course.has_student?(student) && !solved_by?(student)
  end

  def graded_for?(student)
    solution_by(student)&.graded?
  end

  def status_for(student)
    return 'nierozwiązane' unless solved_by? student
    return 'ocenione' if graded_for? student
    'czeka na sprawdzenie'
  end

  def earned_points_by(student)
    solution_by(student)&.earned_points
  end

  def avg_score
    graded_points = solutions.graded.map(&:earned_points)
    return if graded_points.empty?
    graded_points.sum / graded_points.size
  end

  private

  def enrollment(student)
    student.enrollments.find_by(course: course)
  end
end
