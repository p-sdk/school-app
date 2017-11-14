require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  subject { Class.new.include(described_class).new }

  describe '#markdown' do
    arg = '# Header'

    it 'converts markdown to HTML' do
      expect(subject.markdown(arg)).to eq "<h1>Header</h1>\n"
    end
  end

  describe '#alert_name' do
    it 'does not change bootstrap alerts classes' do
      %i[success info warning danger].each do |name|
        expect(subject.alert_name(name)).to eq name
      end
    end

    it "converts flash names to bootstrap alert names" do
      expect(subject.alert_name(:notice)).to eq :success
      expect(subject.alert_name(:foobar)).to eq :info
      expect(subject.alert_name(:alert)).to eq :warning
      expect(subject.alert_name(:error)).to eq :danger
    end
  end
end
