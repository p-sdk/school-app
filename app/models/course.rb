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
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (teacher_id => users.id)
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

  def has_student?(student)
    students.include? student
  end

  def to_param
    "#{id}-#{name}".parameterize
  end
end
