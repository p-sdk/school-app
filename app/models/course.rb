# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  desc        :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#  teacher_id  :integer
#
# Indexes
#
#  index_courses_on_category_id  (category_id)
#  index_courses_on_teacher_id   (teacher_id)
#

class Course < ApplicationRecord
  belongs_to :teacher, class_name: 'User'
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
  has_many :lectures, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :solutions, through: :tasks

  belongs_to :category

  validates :name,
            presence: true,
            uniqueness: true,
            length: { in: 3..200 }

  validates :desc, length: { maximum: 100_000 }

  def studied_by?(student)
    students.include? student
  end

  def to_param
    "#{id}-#{name}".parameterize
  end
end
