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
#  teacher                 :boolean          default(FALSE)
#  upgrade_request_sent_at :datetime
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password 'foobar'
    password_confirmation 'foobar'

    factory :teacher do
      teacher true
    end

    factory :admin do
      email { Rails.application.config.admin_email }
    end
  end
end
