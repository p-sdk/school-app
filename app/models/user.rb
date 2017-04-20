# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  name                    :string
#  email                   :string
#  password_digest         :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  upgrade_request_sent_at :datetime
#  encrypted_password      :string           default(""), not null
#  reset_password_token    :string
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :inet
#  last_sign_in_ip         :inet
#  role                    :integer          default(0)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  ROLES = %i(student teacher admin)

  enum role: ROLES

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :teacher_courses, class_name: 'Course', foreign_key: :teacher_id, dependent: :destroy
  has_many :enrollments, foreign_key: :student_id, dependent: :destroy
  has_many :courses, through: :enrollments

  before_save { email.downcase! }

  scope :requesting_upgrade, -> { where.not(upgrade_request_sent_at: nil) }

  validates :name,
            presence: true,
            length: { in: 3..50 }

  def enrolled_in?(course)
    courses.include? course
  end

  def enroll_in(course)
    enrollments.create!(course: course)
  end

  def request_upgrade
    return if teacher?
    update! upgrade_request_sent_at: Time.current
  end

  def requesting_upgrade?
    upgrade_request_sent_at.present?
  end

  def approve_upgrade_request
    teacher!
    update! upgrade_request_sent_at: nil
  end

  def reject_upgrade_request
    update! upgrade_request_sent_at: nil
  end
end
