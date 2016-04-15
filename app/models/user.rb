# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  teacher         :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ActiveRecord::Base
  has_secure_password
  has_many :teacher_courses, class_name: 'Course', foreign_key: :teacher_id
  has_many :enrollments, foreign_key: :student_id
  has_many :courses, through: :enrollments

  before_save { email.downcase! }

  scope :requesting_upgrade, -> { where(teacher: nil) }
  scope :teachers, -> { where(teacher: true) }
  scope :students, -> { where.not(teacher: true) }

  validates :name,
            presence: true,
            length: { in: 3..50 }

  validates :email,
            presence: true,
            length: { in: 5..100 },
            uniqueness: { case_sensitive: false },
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  validates :password, length: { in: 5..60 }
  validates :password_confirmation, presence: true

  def enrolled_in?(course)
    courses.include? course
  end

  def enroll_in(course)
    enrollments.create!(course: course)
  end

  def admin?
    email == Rails.configuration.admin_email
  end

  def request_upgrade
    return if teacher?
    update_attribute :teacher, nil
  end

  def requesting_upgrade?
    teacher.nil?
  end

  def upgrade
    update_attribute :teacher, true
  end

  def downgrade
    update_attribute :teacher, false
  end
end
