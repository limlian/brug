Given /系统中没有email为(.*)的用户/ do |email|
  user = User.find_by_email(email)
  if user
    user.destroy
  end
end

Given /系统中已经有email为(.*)的用户/ do |email|
  @user = User.find_by_email(email)
  if @user.nil?
    @user = User.create!({
                   :email => email,
                   :username => 'demo',
                   :fname => 'demo',
                   :lname => 'demo',
                   :password => 'changeme'
                 })
  end
end

When /我填入(.*)的注册信息/ do |email|
  fills_in "user[fname]", :with => "demo"
  fills_in "user[lname]", :with => "demo"
  fills_in "user[username]", :with => "demo"
  fills_in "user[email]", :with => email
  fills_in "user[password]", :with => "changeme"
  fills_in "user[password_confirmation]", :with => "changeme"  
end


Given /我访问网站注册页面/ do
  visits "/users/new"
end

When /点击(\w+)按钮/ do |button|
  clicks_button button
end

Then /系统中将有email为(.*)的用户/ do |email|
  User.find_by_email(email).should_not be_nil
end

Then /系统中将不会有email为(.*)的用户/ do |email|
  User.find_by_email(email).should be_nil
end

Then /我应该到达(.*)页面/ do |page|
  response.should render_template(page)
end

Then /我应该看到(.*)的信息/ do |msg|
  response.should include_text(msg)
end
