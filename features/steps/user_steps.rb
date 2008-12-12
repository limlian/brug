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

Then /系统中将有email为(.*)的用户/ do |email|
  User.find_by_email(email).should_not be_nil
end

Then /系统中将不会有email为(.*)的用户/ do |email|
  User.find_by_email(email).should be_nil
end
