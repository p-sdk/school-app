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

class Course < ActiveRecord::Base
  belongs_to :teacher, class_name: 'User', required: true
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, source: :student
  has_many :lectures, dependent: :destroy
  has_many :tasks, dependent: :destroy

  belongs_to :category
  validates :category, presence: true

  validates :name,
            presence: true,
            uniqueness: true,
            length: { in: 3..200 }

  validates :desc, length: { maximum: 100_000 }

  def has_student?(student)
    students.include? student
  end

  def points
    tasks.map(&:points).sum
  end

  def earned_points_by(student)
    tasks.map { |task| task.earned_points_by student }.compact.sum
  end
end
