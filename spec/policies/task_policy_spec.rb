require 'rails_helper'

RSpec.describe TaskPolicy do
  subject { described_class.new(user, task) }

  let(:task) { create :task }
  let(:course) { task.course }

  context 'being a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_actions(%i[index show create update destroy]) }
  end

  context 'being a user' do
    let(:user) { build_stubbed :user }

    it { is_expected.to forbid_actions(%i[index show create update destroy]) }
  end

  context 'being the course student' do
    let(:user) { u = create :user; u.enroll_in(course); u }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[index create update destroy]) }
  end

  context 'being a teacher' do
    let(:user) { build_stubbed :teacher }

    it { is_expected.to forbid_actions(%i[index show create update destroy]) }
  end

  context 'being the course teacher' do
    let(:user) { course.teacher }

    it { is_expected.to permit_actions(%i[show create update destroy]) }
    it { is_expected.to forbid_action(:index) }
  end
end
