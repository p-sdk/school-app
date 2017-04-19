require 'rails_helper'

RSpec.describe ApplicationHelper do
  subject { Class.new.include(described_class).new }

  describe '#markdown' do
    arg = '# Header'

    it 'converts markdown to HTML' do
      expect(subject.markdown(arg)).to eq "<h1>Header</h1>\n"
    end
  end
end
