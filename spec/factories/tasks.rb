# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  desc       :text
#  points     :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :integer          not null
#
# Indexes
#
#  index_tasks_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#

FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Task #{n}" }
    desc { Faker::Lorem.sentence }
    points { rand 50..100 }
    association :course
  end
end
