require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  #Delete this example and add some real ones
  it "should use UsersController" do
    controller.should be_an_instance_of(UsersController)
  end

  it "should have correct routes" do
    params_from(:get, "/users").should == {:controller => "users", :action => "index"}
    params_from(:post, "/users").should == {:controller => "users", :action => "create"}
    params_from(:get, "/users/new").should == {:controller => "users", :action => "new"}
  end

end

describe UsersController do
  before(:each) do
    @user = mock("user")

    @user.stub!(:new_record?).and_return(false)
    @user.stub!(:errors).and_return([])
    User.stub!(:new).and_return(@user)

    @user_hash = {"fname" => "liming", 
                  "lname" => "lian",
                  "username" => "limlian",
                  "email" => "lianliming@gmail.com",
                  "password" => "changeme",
                  "password_confirmation" => "changeme"}
  end

  it "should create a new, unsaved user on http Get to new " do
    User.should_receive(:new).and_return(@user)
    get "new"
  end

  it "should create a User model on create action when success" do
    User.should_receive(:new).with(@user_hash).and_return(@user)
    @user.should_receive(:save).and_return(true)

    post "create", {:user => @user_hash}
    response.should redirect_to(:controller=> "login")    
  end

  it "should not create a user model on create action when failure" do
    User.should_receive(:new).with(@user_hash).and_return(@user)
    @user.should_receive(:save).and_return(false)

    post "create", {:user => @user_hash}
    response.should render_template(:new)
  end
end

describe UsersController do
  integrate_views

  before(:each) do
    @user = mock("user")
    @errors = mock("errors")
    
    @user.stub!(:new_record?).and_return(false)
    @user.stub!(:errors).and_return(@errors)
    @errors.stub!(:count).and_return(0)
    User.stub!(:new).and_return(@user)
  end

  it "should create a new, unsaved user on http Get to new " do
    User.should_receive(:new).and_return(@user)
    @user.should_receive(:fname).and_return(nil)
    @user.should_receive(:lname).and_return(nil)
    @user.should_receive(:username).and_return(nil)
    @user.should_receive(:email).and_return(nil)
    @user.should_receive(:password).and_return(nil)
    @user.should_receive(:password_confirmation).and_return(nil)
    get "new"

    response.should be_success
    response.should render_template(:new)

    response.should have_tag('div#registration-form > form[action="http://test.host/users"]') do
      with_tag("input[name='user[fname]']")
      with_tag("input[name='user[lname]']")
      with_tag("input[name='user[username]']")
      with_tag("input[name='user[email]']")
      with_tag("input[name='user[password]']")
      with_tag("input[name='user[password_confirmation]']")
      with_tag("input[type=submit]")
    end
  end
end

describe "/users/show/1" do
  controller_name :users
  integrate_views

  before(:each) do
    @demo_user1 = mock("user")
    @demo_user2 = mock("user")
    @demo_user3 = mock("user")
    User.stub!(:find).with(1).and_return(@demo_user1)
    User.stub!(:find).with(2).and_return(@demo_user2)

    @demo_user1.stub!(:friends).and_return([@demo_user2, @demo_user3])
  end

  it "should log in to view user page" do
    session[:user_id] = nil
    get 'show', :id => 1
    response.should redirect_to(:controller => "login")
  end
  
  it "should display correctly when visit my friend's user page" do
    User.should_receive(:find_by_id).with("1").once.and_return(@demo_user1)
    @demo_user1.should_receive(:fname).and_return('demo1')
    @demo_user1.should_receive(:lname).and_return('demo1')
    @demo_user1.should_receive(:is_my_friend?).with(@demo_user2).and_return(true)
    User.should_receive(:find_by_id).with(2).and_return(@demo_user2)
    @demo_user1.should_receive(:friends).and_return([@demo_user2, @demo_user3])

    @demo_user2.should_receive(:fname).and_return('demo2')
    @demo_user2.should_receive(:lname).and_return('demo2')
    @demo_user3.should_receive(:fname).and_return('demo3')
    @demo_user3.should_receive(:lname).and_return('demo3')

    session[:user_id] = 2
    get 'show', :id => 1

    response.should_not redirect_to(:controller => "login")
    response.should be_success
    response.should render_template(:show)

    response.should have_tag('div#user-info') do
      with_tag('div#user-name', 'demo1 demo1')
    end
    
    response.should have_tag('ul#friends-list') do
      with_tag('li', 'demo2 demo2')
      with_tag('li', 'demo3 demo3')
    end
    
  end

  it "should display correctly when visit page of user who isn't my friend" do
    User.should_receive(:find_by_id).with("1").once.and_return(@demo_user1)
    @demo_user1.should_receive(:fname).and_return('demo1')
    @demo_user1.should_receive(:lname).and_return('demo1')
    @demo_user1.should_receive(:is_my_friend?).with(@demo_user2).and_return(false)
    @demo_user1.should_receive(:friends).and_return([@demo_user3])

    User.should_receive(:find_by_id).with(2).and_return(@demo_user2)
    @demo_user2.should_receive(:id).and_return(2)

    @demo_user3.should_receive(:fname).and_return('demo3')
    @demo_user3.should_receive(:lname).and_return('demo3')

    session[:user_id] = 2
    get 'show', :id => 1

    response.should_not redirect_to(:controller => "login")
    response.should be_success
    response.should render_template(:show)

    response.should have_tag('div#user-info') do
      with_tag('div#user-name', 'demo1 demo1')
    end

    response.should have_tag("form") do
      with_tag("input[name=invitation_user_id][type=hidden][value=2]")
      with_tag("input[name=status][type=hidden][value='pending']")
      with_tag("input[type=submit][value='Add as friend']")
    end
    
    response.should have_tag('ul#friends-list') do
      with_tag('li', 'demo3 demo3')
    end

  end
end
