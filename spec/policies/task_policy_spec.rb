require 'rails_helper'

RSpec.describe TaskPolicy do
  subject { described_class }

  let(:task) { create :task }
  let(:course) { task.course }
  let(:teacher) { course.teacher }
  let(:other_teacher) { build_stubbed :teacher }
  let(:student) { u = create :user; u.enroll_in course; u }
  let(:other_user) { build_stubbed :user }

  permissions :show? do
    it { is_expected.to_not permit(nil, task) }
    it { is_expected.to permit(teacher, task) }
    it { is_expected.to_not permit(other_teacher, task) }
    it { is_expected.to permit(student, task) }
    it { is_expected.to_not permit(other_user, task) }
  end

  permissions :create?, :update?, :destroy? do
    it { is_expected.to_not permit(nil, task) }
    it { is_expected.to permit(teacher, task) }
    it { is_expected.to_not permit(other_teacher, task) }
    it { is_expected.to_not permit(student, task) }
    it { is_expected.to_not permit(other_user, task) }
  end
end
