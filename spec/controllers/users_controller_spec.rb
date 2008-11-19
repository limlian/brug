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
    response.should redirect_to(:action => "new")    
  end
end

describe UsersController do
  integrate_views

  before(:each) do
    @user = mock("user")

    @user.stub!(:new_record?).and_return(false)
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
