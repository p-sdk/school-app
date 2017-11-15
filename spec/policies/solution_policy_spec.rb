require 'rails_helper'

RSpec.describe SolutionPolicy do
  subject { described_class.new(user, solution) }

  let(:solution) { create :solution }
  let(:course) { solution.task.course }

  context 'being a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_actions(%i[index show create update destroy]) }
  end

  context 'being a user' do
    let(:user) { build_stubbed :user }

    it { is_expected.to forbid_actions(%i[index show create update destroy]) }
  end

  context 'being the course student' do
    let(:user) { create :student, course: course }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to forbid_actions(%i[index show update destroy]) }
  end

  context 'being the solution submitter' do
    let(:user) { solution.enrollment.student }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[index create update destroy]) }
  end

  context 'being a teacher' do
    let(:user) { build_stubbed :teacher }

    it { is_expected.to forbid_actions(%i[index show create update destroy]) }
  end

  context 'being the course teacher' do
    let(:user) { course.teacher }

    it { is_expected.to permit_actions(%i[show update destroy]) }
    it { is_expected.to forbid_actions(%i[index create]) }
  end
end
