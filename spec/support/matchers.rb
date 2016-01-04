RSpec::Matchers.define :have_error_message do |msg|
  match do |page|
    page.has_selector? 'div.alert.alert-danger', text: msg
  end
end

RSpec::Matchers.define :have_success_message do |msg|
  match do |page|
    page.has_selector? 'div.alert.alert-success', text: msg
  end
end
