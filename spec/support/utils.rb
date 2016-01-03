def sign_in_as(user)
  visit signin_path
  fill_in 'Email', with: user.email
  fill_in 'Hasło', with: user.password
  click_button 'Zaloguj'
rescue NoMethodError
  begin
    session[:user_id] = user.id
  rescue
    post sessions_path, session: { email: user.email, password: user.password }
  end
end

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
