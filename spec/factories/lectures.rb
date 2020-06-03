# == Schema Information
#
# Table name: lectures
#
#  id                      :integer          not null, primary key
#  attachment_content_type :string
#  attachment_file_name    :string
#  attachment_file_size    :bigint
#  attachment_updated_at   :datetime
#  content                 :text
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  course_id               :integer          not null
#
# Indexes
#
#  index_lectures_on_course_id  (course_id)
#

FactoryBot.define do
  factory :lecture do
    sequence(:title) { |n| "Lecture #{n}" }
    content { Faker::Lorem.sentence }
    association :course
  end
end
