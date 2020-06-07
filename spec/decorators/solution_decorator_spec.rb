require 'spec_helper'

RSpec.describe SolutionDecorator do
  let(:solution) { build(:solution).decorate }

  describe '#content_formatted' do
    subject { solution.content_formatted }

    before do
      solution.content = '# Header'
    end

    it { is_expected.to eq "<h1>Header</h1>\n" }
  end

  describe '#earned_points_formatted' do
    subject { solution.earned_points_formatted }

    context 'solution not graded' do
      it { is_expected.to eq 'Rozwiązanie czeka na sprawdzenie' }
    end

    context 'solution has been graded' do
      before do
        solution.earned_points = 14
      end

      it { is_expected.to eq 14 }
    end
  end
end
