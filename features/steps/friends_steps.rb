Given /^系统中没有用户$/ do 
  User.delete_all
end

Given /^系统添加(.*)用户$/ do |email|
  User.create!({
        :email => email,
        :username => email,
        :fname => email,
        :lname => email,
        :password => 'changeme'
         })
end

Given /^(.*)是(.*)的好友$/ do |email1, email2|
  user1 = User.find_by_email(email1)
  user2 = User.find_by_email(email2)

  user1.add_friend(user2) unless user1.is_my_friend? user2
end

Given /^(.*)用户没有朋友$/ do |email|
  user = User.find_by_email(email)

  if user.has_friends?
    user.remove_all_friends
  end
end

Given /^我用(.*)用户登录$/ do |email|
  post '/login/login', {:email => email, :password => 'changeme'}
end

When /^访问(.*)的消息页面$/ do |email|
  user = User.find_by_email(email)  
  get user_messages_url(user.id)
end

When /^访问(.*)用户页面$/ do |email|
  user = User.find_by_email(email)  
  get user_url(user)
end

When /^我删除好友(.*)$/ do |email|
  raise "unimplemented"  
end

When /^我接受(.*)的朋友请求$/ do |email|
  raise "unimplemented"  
end

Then /^我应该看到(.*)的添加好友请求$/ do |email|
  invitation_user = User.find_by_email(email)

  response.should include_text(invitation_user.fname + ' ' + invitation_user.lname + ' invites you as friend')
end

Then /^我应该在(.*)列表里面看不到(.*)用户$/ do |list, email|
  user = User.find_by_email(email)  

  response.should_not have_tag('ul#' + list) do
    with_tag('li', user.fname + ' ' + user.lname)
  end
end 

Then /^我应该在(.*)列表里面看到(.*)用户$/ do |list, email|
  user = User.find_by_email(email)  

  response.should have_tag('ul#' + list) do
    with_tag('li', user.fname + ' ' + user.lname)
  end
end
