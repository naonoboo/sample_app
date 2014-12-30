# -*- coding: utf-8 -*-

def valid_signin(user)
  # visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
  	expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_welcome_message do |message|
  match do |page|
  	expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end

def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
  	base_title
  else
  	"#{base_title} | #{page_title}"
  end
end

# signin_in では正しく動作しないため、test_signin_in に変更
def test_sign_in(user, options={})
  if options[:no_capybara]
    # Capybaraを使用していない場合にもサインインする。
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

