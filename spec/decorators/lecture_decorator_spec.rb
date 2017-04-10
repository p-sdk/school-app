require 'spec_helper'

RSpec.describe LectureDecorator do
  let(:lecture) { build(:lecture).decorate }

  describe '#content_formatted' do
    subject { lecture.content_formatted }

    before do
      lecture.content = '# Header'
    end

    it { is_expected.to eq "<h1>Header</h1>\n" }
  end

  describe '#attachment_file_size_formatted' do
    subject { lecture.attachment_file_size_formatted }

    before do
      allow(lecture).to receive(:attachment_file_size).and_return(12_345_678)
    end

    it { is_expected.to eq '( 11.8 MB )' }
  end
end
