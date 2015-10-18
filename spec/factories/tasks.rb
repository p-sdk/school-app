# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  title      :string
#  desc       :text
#  points     :integer
#  course_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tasks_on_course_id  (course_id)
#

FactoryGirl.define do
  factory :task do
    sequence(:title) { |n| "Task #{n}" }
    desc { Faker::Lorem.sentence }
    points { rand 50..100 }
    association :course
  end
end
