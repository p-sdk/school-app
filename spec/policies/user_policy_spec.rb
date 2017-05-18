require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

  let(:user) { create :user }
  let(:admin) { build_stubbed :admin }

  permissions :index? do
    it { is_expected.to_not permit(nil) }
    it { is_expected.to_not permit(user) }
    it { is_expected.to permit(admin) }
  end

  permissions :show? do
    it { is_expected.to permit(nil, user) }
    it { is_expected.to permit(user, user) }
    it { is_expected.to permit(admin, user) }
  end

  permissions :update? do
    it { is_expected.to_not permit(nil, user) }
    it { is_expected.to_not permit(user, user) }
    it { is_expected.to permit(admin, user) }
  end
end
