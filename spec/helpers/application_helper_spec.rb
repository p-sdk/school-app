require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
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

    it "converts flash names to bootstrap alert names" do
      expect(helper.alert_name(:notice)).to eq :success
      expect(helper.alert_name(:foobar)).to eq :info
      expect(helper.alert_name(:alert)).to eq :warning
      expect(helper.alert_name(:error)).to eq :danger
    end
  end

  describe '#btn_to' do
    let(:name) { 'Foo Bar' }
    let(:url) { '/foobar' }

    it "sets class to 'btn btn-default'" do
      expect(helper.btn_to(name, url)).to eq link_to(name, url, class: 'btn btn-default')
    end

    it 'works with blocks' do
      expect(helper.btn_to(url) { name }).to eq link_to(url, class: 'btn btn-default') { name }
    end

    it 'can set custom context' do
      expect(helper.btn_to(name, url, context: :primary)).to eq link_to(name, url, class: 'btn btn-primary')
    end

    it 'can set custom context, method, class and block' do
      expect(helper.btn_to(url, context: :primary, method: :delete, class: 'btn-sm') { name }).to eq link_to(url, method: :delete, class: 'btn btn-primary btn-sm') { name }
    end
  end
end
