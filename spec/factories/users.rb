# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  name                    :string
#  email                   :string
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

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password 'foobar'
    password_confirmation 'foobar'

    factory :student do
      transient do
        course { build :course }
      end

      after(:create) do |user, evaluator|
        user.courses << evaluator.course
      end
    end

    factory :teacher do
      role :teacher
    end

    factory :admin do
      role :admin
    end
  end
end
