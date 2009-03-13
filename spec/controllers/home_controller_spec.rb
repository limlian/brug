require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do

  #Delete this example and add some real ones
  it "should use HomeController" do
    controller.should be_an_instance_of(HomeController)
  end

  it "should have correct routes" do
    params_from(:get, "/home").should == {:controller => "home", :action => "index"}    
  end
end


describe HomeController, "limit access" do
  before(:each) do
    @user = mock("user")
    User.stub!(:find_by_id).with(1).and_return(@user)
  end
  
  it "should redirect to login page if user hasn't logged in" do
    session[:user_id] = nil
    get "index"
    response.should redirect_to(:controller => "login")
  end

  it "shouldn't redirect if user has logged in" do
    session[:user_id] = 1
    User.should_receive(:find_by_id).with(1).and_return(@user)
    get "index"
    response.should render_template(:index)
  end
end

describe HomeController, "integrated with views" do
  integrate_views
  
  before(:each) do
    @user = mock("user")
    User.stub!(:find_by_id).with(1).and_return(@user)
    @user.stub!(:fname).and_return('demo')
    @user.stub!(:lname).and_return('demo')
    @user.stub!(:id).and_return(1)
  end

  it "should see the home when having logged in" do
    User.should_receive(:find_by_id).with(1).and_return(@user)
    @user.should_receive(:id).and_return(1)

    session[:user_id] = 1
    get 'index'
  end
end
