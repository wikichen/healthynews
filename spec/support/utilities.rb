include ApplicationHelper

def login(user)
  visit login_path
  fill_in "Login",    with: user.username
  fill_in "Password", with: user.password
  click_button "Login"
end