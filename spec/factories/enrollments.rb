# == Schema Information
#
# Table name: enrollments
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :integer          not null
#  student_id :integer          not null
#
# Indexes
#
#  index_enrollments_on_course_id                 (course_id)
#  index_enrollments_on_student_id                (student_id)
#  index_enrollments_on_student_id_and_course_id  (student_id,course_id) UNIQUE
#

FactoryBot.define do
  factory :enrollment do
    association :student, factory: :user
    association :course

    factory :enrollment_with_solution do
      transient do
        task_to_solve { create :task, course: course }
        earned_points { nil }
      end

      after(:create) do |enrollment, evaluator|
        create :solution,
               enrollment: enrollment,
               task: evaluator.task_to_solve,
               earned_points: evaluator.earned_points
      end
    end
  end
end
