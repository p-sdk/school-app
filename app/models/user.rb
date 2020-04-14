# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  confirmation_sent_at    :datetime
#  confirmation_token      :string
#  confirmed_at            :datetime
#  current_sign_in_at      :datetime
#  current_sign_in_ip      :string
#  email                   :string
#  encrypted_password      :string           default(""), not null
#  last_sign_in_at         :datetime
#  last_sign_in_ip         :string
#  name                    :string
#  remember_created_at     :datetime
#  reset_password_sent_at  :datetime
#  reset_password_token    :string
#  role                    :integer          default("student")
#  sign_in_count           :integer          default(0), not null
#  unconfirmed_email       :string
#  upgrade_request_sent_at :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  ROLES = %i[student teacher admin]

  enum role: ROLES

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
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

  def to_param
    "#{id}-#{name}".parameterize
  end
end
