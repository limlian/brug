Given /^there is no existed user with email "(.*)"$/ do |email|
  user = User.find_by_email(email)
  if user
    user.destroy
  end
end

Given /^there is already existed user with email "(.*)"$/ do |email|
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

When /^I fill in "(.*)" registration information$/ do |email|
  fill_in "user[fname]", :with => "demo"
  fill_in "user[lname]", :with => "demo"
  fill_in "user[username]", :with => "demo"
  fill_in "user[email]", :with => email
  fill_in "user[password]", :with => "changeme"
  fill_in "user[password_confirmation]", :with => "changeme"  
end

Then /^there is existed user with email "(.*)"$/ do |email|
  User.find_by_email(email).should_not be_nil
end
