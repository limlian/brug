When /^我访问(.*)页面$/ do |page|
  visit page
end

When /^我点击(.*)按钮$/ do |button|
  click_button button
end

Then /^我应该到达(.*)页面$/ do |page|
  response.should render_template(page)
end

Then /^我应该看到(.*)的信息$/ do |msg|
  response.body.should =~ /#{msg}/m
end
