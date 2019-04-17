# == Schema Information
#
# Table name: solutions
#
#  id            :integer          not null, primary key
#  enrollment_id :integer          not null
#  task_id       :integer          not null
#  content       :text
#  earned_points :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_solutions_on_enrollment_id              (enrollment_id)
#  index_solutions_on_enrollment_id_and_task_id  (enrollment_id,task_id) UNIQUE
#  index_solutions_on_task_id                    (task_id)
#
# Foreign Keys
#
#  fk_rails_...  (enrollment_id => enrollments.id)
#  fk_rails_...  (task_id => tasks.id)
#

FactoryBot.define do
  factory :solution do
    association :enrollment
    task { build :task, course: enrollment.course }
    content { Faker::Lorem.sentence }

    factory :graded_solution do
      earned_points { rand 10..30 }
    end
  end
end
