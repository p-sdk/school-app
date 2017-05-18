require 'rails_helper'

RSpec.describe CategoryPolicy do
  subject { described_class }

  let(:category) { create :category }
  let(:user) { build_stubbed :user }
  let(:admin) { build_stubbed :admin }

  permissions :index? do
    it { is_expected.to permit(nil) }
    it { is_expected.to permit(user) }
    it { is_expected.to permit(admin) }
  end

  permissions :show? do
    it { is_expected.to permit(nil, category) }
    it { is_expected.to permit(user, category) }
    it { is_expected.to permit(admin, category) }
  end

  permissions :create?, :update?, :destroy? do
    it { is_expected.to_not permit(nil, category) }
    it { is_expected.to_not permit(user, category) }
    it { is_expected.to permit(admin, category) }
  end
end
