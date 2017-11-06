require 'rails_helper'

RSpec.describe CoursePolicy do
  subject { described_class }

  let(:course) { create :course }
  let(:teacher) { course.teacher }
  let(:other_teacher) { build_stubbed :teacher }
  let(:student) { u = create :user; u.enroll_in course; u }
  let(:other_user) { build_stubbed :user }

  permissions :index? do
    it { is_expected.to permit(nil) }
    it { is_expected.to permit(teacher) }
    it { is_expected.to permit(other_teacher) }
    it { is_expected.to permit(student, course) }
    it { is_expected.to permit(other_user) }
  end

  permissions :show? do
    it { is_expected.to permit(nil, course) }
    it { is_expected.to permit(teacher, course) }
    it { is_expected.to permit(other_teacher, course) }
    it { is_expected.to permit(student, course) }
    it { is_expected.to permit(other_user, course) }
  end

  permissions :create? do
    it { is_expected.to_not permit(nil, course) }
    it { is_expected.to permit(teacher, course) }
    it { is_expected.to permit(other_teacher, course) }
    it { is_expected.to_not permit(student, course) }
    it { is_expected.to_not permit(other_user, course) }
  end

  permissions :update?, :destroy? do
    it { is_expected.to_not permit(nil, course) }
    it { is_expected.to permit(teacher, course) }
    it { is_expected.to_not permit(other_teacher, course) }
    it { is_expected.to_not permit(student, course) }
    it { is_expected.to_not permit(other_user, course) }
  end

  permissions :list_lectures?, :list_tasks? do
    it { is_expected.to_not permit(nil, course) }
    it { is_expected.to permit(teacher, course) }
    it { is_expected.to_not permit(other_teacher, course) }
    it { is_expected.to permit(student, course) }
    it { is_expected.to_not permit(other_user, course) }
  end
end
