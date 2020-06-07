require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#markdown' do
    arg = '# Header'

    it 'converts markdown to HTML' do
      expect(helper.markdown(arg)).to eq "<h1>Header</h1>\n"
    end
  end

  describe '#alert_name' do
    it 'does not change bootstrap alerts classes' do
      %i[success info warning danger].each do |name|
        expect(helper.alert_name(name)).to eq name
      end
    end

    it 'converts flash names to bootstrap alert names' do
      expect(helper.alert_name(:notice)).to eq :success
      expect(helper.alert_name(:foobar)).to eq :info
      expect(helper.alert_name(:alert)).to eq :warning
      expect(helper.alert_name(:error)).to eq :danger
    end
  end
end
