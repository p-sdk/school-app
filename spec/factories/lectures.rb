# == Schema Information
#
# Table name: lectures
#
#  id                      :integer          not null, primary key
#  title                   :string
#  content                 :text
#  course_id               :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#
# Indexes
#
#  index_lectures_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_bbbf25c9a6  (course_id => courses.id)
#

FactoryGirl.define do
  factory :lecture do
    sequence(:title) { |n| "Lecture #{n}" }
    content { Faker::Lorem.sentence }
    association :course
  end

end
