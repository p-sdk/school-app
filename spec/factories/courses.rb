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

FactoryGirl.define do
  factory :course do
    sequence(:name) { |n| "Course #{n}" }
    desc { Faker::Lorem.sentence }
    association :teacher
    association :category
  end
end
