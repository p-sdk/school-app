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
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (teacher_id => users.id)
#

FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "Course #{n}" }
    desc { Faker::Lorem.sentence }
    association :teacher
    association :category

    factory :course_with_tasks do
      transient do
        tasks_count { 3 }
      end

      after(:create) do |course, evaluator|
        create_list :task, evaluator.tasks_count, course: course
      end
    end
  end
end
