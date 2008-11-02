Given /系统中没有用户名为(.*)的用户/ do |name|
  if User.exists?(name)
    User.remove_user(name)
  end
end

Given /系统中已经有用户名为(.*)的用户/ do |name|
  User.exists?(name).should == true  
end

When /我填入(.*)的注册信息/ do |name|
end


Given /我访问网站注册页面/ do
  #visits "/users/new"
end

When /点击(\w+)按钮/ do |button|
  #raise "unimplemented!"
end

Then /我应该看到(.*)的信息/ do |msg|
  #raise "unimplemented!"
end
