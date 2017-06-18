require 'rails_helper'

RSpec.describe LecturePolicy do
  subject { described_class }

  let(:lecture) { create :lecture }
  let(:course) { lecture.course }
  let(:teacher) { course.teacher }
  let(:other_teacher) { build_stubbed :teacher }
  let(:student) { u = create :user; u.enroll_in course; u }
  let(:other_user) { build_stubbed :user }

  permissions :show? do
    it { is_expected.to_not permit(nil, lecture) }
    it { is_expected.to permit(teacher, lecture) }
    it { is_expected.to_not permit(other_teacher, lecture) }
    it { is_expected.to permit(student, lecture) }
    it { is_expected.to_not permit(other_user, lecture) }
  end

  permissions :create?, :update?, :destroy? do
    it { is_expected.to_not permit(nil, lecture) }
    it { is_expected.to permit(teacher, lecture) }
    it { is_expected.to_not permit(other_teacher, lecture) }
    it { is_expected.to_not permit(student, lecture) }
    it { is_expected.to_not permit(other_user, lecture) }
  end
end
