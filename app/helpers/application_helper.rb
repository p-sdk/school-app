module ApplicationHelper
  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis]
    Markdown.new(text, *options).to_html.html_safe
  end

  def alert_name(flash_name)
    return flash_name if %i[success info warning danger].include? flash_name
    map = Hash.new(:info).merge(notice: :success, alert: :warning, error: :danger)
    map[flash_name]
  end

  def btn_to(*args, **kwargs, &block)
    context = kwargs.delete(:context) { :default }
    classes = %W[btn btn-#{context}] + kwargs[:class].to_s.split
    kwargs[:class] = classes.join(' ')
    link_to(*args, **kwargs, &block)
  end
end
