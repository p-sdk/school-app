require 'spec_helper'

RSpec.describe CategoryDecorator do
  let(:category) { build(:category).decorate }

  describe '#courses_count_formatted' do
    subject { category.courses_count_formatted }

    context 'with no courses' do
      it { is_expected.to eq '( 0 )' }
    end

    context 'with one course' do
      before { create(:course, category: category) }
      it { is_expected.to eq '( 1 )' }
    end

    context 'with five courses' do
      before { create_list(:course, 5, category: category) }
      it { is_expected.to eq '( 5 )' }
    end
  end
end
