Given /^there is no user in the system$/ do 
  User.delete_all
end

Given /^add a new user "(.*)"$/ do |email|
  User.create!({
        :email => email,
        :username => email,
        :fname => email,
        :lname => email,
        :password => 'changeme'
         })  
end

Given /^"(.*)" has no friends$/ do |email|
  user = User.find_by_email(email)

  if user.has_friends?
    user.remove_all_friends
  end  
end

When /^I log in as "(.*)"$/ do |email|
  post '/login/login', {:email => email, :password => 'changeme'}  
end

When /^I visit "(.*)" user page$/ do |email|
  user = User.find_by_email(email)  
  get user_url(user)
end

Given /^I visit "(.*)" message page$/ do |email|
  user = User.find_by_email(email)  
  get user_messages_url(user.id)  
end

Then /^I should not see user "(.*)" in the "(.*)"$/ do |email, list|
  user = User.find_by_email(email)  

  response.should_not have_tag('ul#' + list) do
    with_tag('li', user.fname + ' ' + user.lname)
  end  
end

Then /^I should see user "(.*)" in the "(.*)"$/ do |email, list|
  user = User.find_by_email(email)  

  response.should have_tag('ul#' + list) do
    with_tag('li', user.fname + ' ' + user.lname)
  end  
end

Then /^I should see friend request from "(.*)"$/ do |email| 
  invitation_user = User.find_by_email(email)

  response.should include_text(invitation_user.fname + ' ' + invitation_user.lname + ' invites you as friend')  
end
