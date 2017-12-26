require 'rails_helper'

RSpec.describe CategoryPolicy do
  subject { described_class.new(user, category) }

  let(:category) { create :category }

  context 'being a visitor' do
    let(:user) { nil }

    it { is_expected.to permit_actions(%i[index show]) }
    it { is_expected.to forbid_actions(%i[create update destroy]) }
  end

  context 'being a user' do
    let(:user) { build_stubbed :user }

    it { is_expected.to permit_actions(%i[index show]) }
    it { is_expected.to forbid_actions(%i[create update destroy]) }
  end

  context 'being an admin' do
    let(:user) { build_stubbed :admin }

    it { is_expected.to permit_actions(%i[index show create update destroy]) }

    it { is_expected.to permit_mass_assignment_of(:name) }
  end
end
