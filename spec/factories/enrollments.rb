# == Schema Information
#
# Table name: enrollments
#
#  id         :integer          not null, primary key
#  student_id :integer          not null
#  course_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_enrollments_on_course_id                 (course_id)
#  index_enrollments_on_student_id                (student_id)
#  index_enrollments_on_student_id_and_course_id  (student_id,course_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_2e119501f4  (course_id => courses.id)
#  fk_rails_f01c555e06  (student_id => users.id)
#

FactoryGirl.define do
  factory :enrollment do
    association :student, factory: :user
    association :course

    factory :enrollment_with_solution do
      transient do
        task_to_solve { create :task, course: course }
      end

      after(:create) do |enrollment, evaluator|
        create :solution, enrollment: enrollment, task: evaluator.task_to_solve
      end
    end
  end
end
