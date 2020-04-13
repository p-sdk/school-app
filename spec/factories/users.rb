# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  confirmation_sent_at    :datetime
#  confirmation_token      :string
#  confirmed_at            :datetime
#  current_sign_in_at      :datetime
#  current_sign_in_ip      :inet
#  email                   :string
#  encrypted_password      :string           default(""), not null
#  last_sign_in_at         :datetime
#  last_sign_in_ip         :inet
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

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    confirmed_at { Time.zone.now }

    factory :student do
      transient do
        course { build :course }
      end

      after(:create) do |user, evaluator|
        user.courses << evaluator.course
      end
    end

    factory :teacher do
      role { :teacher }

      factory :teacher_with_courses do
        transient do
          courses_count { 3 }
        end

        after(:create) do |teacher, evaluator|
          create_list :course, evaluator.courses_count, teacher: teacher
        end
      end
    end

    factory :admin do
      role { :admin }
    end

    factory :user_requesting_upgrade do
      upgrade_request_sent_at { Time.now }
    end
  end
end
