require 'spec_helper'

RSpec.describe UserDecorator do
  let(:user) { build(:user).decorate }

  describe '#gravatar' do
    subject { user.gravatar }

    let(:url) { 'https://secure.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af?d=identicon' }

    before do
      user.email = 'user@example.com'
      user.name = 'John Johnson'
    end

    it { is_expected.to eq "<img alt=\"John Johnson\" class=\"gravatar\" src=\"#{url}\" />" }
  end
end
