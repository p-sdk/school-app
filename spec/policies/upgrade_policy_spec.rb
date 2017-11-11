require 'rails_helper'

RSpec.describe UpgradePolicy do
  subject { described_class.new(user, :upgrade) }

  context 'being a visitor' do
    let(:user) { nil }

    it { is_expected.to forbid_actions(%i[create update destroy]) }
  end

  context 'being a user' do
    let(:user) { build_stubbed :user }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to forbid_actions(%i[update destroy]) }
  end

  context 'being an admin' do
    let(:user) { build_stubbed :admin }

    it { is_expected.to permit_actions(%i[create update destroy]) }
  end
end
