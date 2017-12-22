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
#  fk_rails_a68eff6aff  (teacher_id => users.id)
#  fk_rails_e072dca946  (category_id => categories.id)
#

class Course < ActiveRecord::Base
  belongs_to :teacher, class_name: 'User', required: true
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
  has_many :lectures, dependent: :destroy
  has_many :tasks, dependent: :destroy

  belongs_to :category, required: true

  validates :name,
            presence: true,
            uniqueness: true,
            length: { in: 3..200 }

  validates :desc, length: { maximum: 100_000 }

  def has_student?(student)
    students.include? student
  end
end
