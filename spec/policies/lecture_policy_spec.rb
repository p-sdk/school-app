require 'rails_helper'

RSpec.describe LecturePolicy do
  subject { described_class.new(user, lecture) }

  let(:lecture) { create :lecture }
  let(:course) { lecture.course }

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

    it { is_expected.to permit_mass_assignment_of(:attachment) }
    it { is_expected.to permit_mass_assignment_of(:content) }
    it { is_expected.to forbid_mass_assignment_of(:course_id) }
    it { is_expected.to permit_mass_assignment_of(:title) }
  end
end
