require 'rails_helper'

RSpec.describe BootstrapHelper do
  describe '#bs_panel' do
    context 'without title' do
      subject { helper.bs_panel { 'Foobar' } }
      it 'renders a panel' do
        is_expected.to match(/panel panel-default/)
        is_expected.to_not match(/panel-heading/)
        is_expected.to_not match(/panel-title/)
        is_expected.to match(%r{<div class='panel-body'>Foobar</div>})
      end
    end

    context 'with title' do
      subject { helper.bs_panel('Foo') { 'Bar' } }
      it 'renders a panel with a title' do
        is_expected.to match(/panel panel-default/)
        is_expected.to match(/panel-heading/)
        is_expected.to match(%r{<h3 class='panel-title'>Foo</h3>})
        is_expected.to match(%r{<div class='panel-body'>Bar</div>})
      end
    end
  end

  describe '#bs_panel_list' do
    let(:items) { "<li>Foo</li>\n<li>Bar</li>".html_safe }

    context 'without title' do
      subject { helper.bs_panel_list { items } }
      it 'renders a panel with a list group' do
        is_expected.to match(/panel panel-default/)
        is_expected.to_not match(/panel-heading/)
        is_expected.to_not match(/panel-title/)
        is_expected.to match(%r{<div class='list-group'>#{items}</div>})
      end
    end

    context 'with title' do
      subject { helper.bs_panel_list('Foobar') { items } }
      it 'renders a panel with a list group and a title' do
        is_expected.to match(/panel panel-default/)
        is_expected.to match(/panel-heading/)
        is_expected.to match(%r{<h3 class='panel-title'>Foobar</h3>})
        is_expected.to match(%r{<div class='list-group'>#{items}</div>})
      end
    end
  end
end
