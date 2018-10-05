module BootstrapHelper
  def bs_panel(title = nil, list: false, &block)
    render 'shared/panel', list: list, title: title, &block
  end

  def bs_panel_list(title = nil, &block)
    bs_panel(title, list: true, &block)
  end
end
