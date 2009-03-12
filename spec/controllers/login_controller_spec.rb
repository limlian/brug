require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginController do

  #Delete this example and add some real ones
  it "should use LoginController" do
    controller.should be_an_instance_of(LoginController)
  end

  it "should have correct route" do
    route_for(:controller => 'login', :action => 'index').should == '/login'
    params_from(:get, "/login").should == {:controller => 'login', :action => 'index'}
  end
end

describe LoginController, "isolated from view" do 

  before(:each) do
    @user = mock("user", :null_object => true)
    
    @user.stub!(:email).and_return("lianliming@gmail.com")
    User.stub!(:authenticate).with("lianliming@gmail.com", "changeme").and_return(@user)
  end

  it "should render login form on GET to index" do
    get 'index'

    response.should render_template(:index)
  end

  it "should go to home if authenitcate successfully" do
    @user.should_receive(:id).once.and_return(99)
    User.should_receive(:authenticate).with("lianliming@gmail.com", "changeme").and_return(@user)
    post 'login', {:email => 'lianliming@gmail.com', :password => 'changeme'}
    session[:user_id].should == 99
    response.should redirect_to(:controller => 'home', :action => 'index')
  end

  it "should go back to login if authenitcate failure" do
    User.should_receive(:authenticate).with("lianliming@gmail.com", "changeyou").and_return(nil)
    post 'login', {:email => 'lianliming@gmail.com', :password => 'changeyou'}
    response.should redirect_to(:action => "index")
    flash[:notice].should == 'Invalid email/password combination'
  end
end

describe LoginController, "integrated with view" do 
  integrate_views
  
  before(:each) do
    @user = mock("user")
    
    @user.stub!(:email).and_return("lianliming@gmail.com")
    User.stub!(:authenticate).with("lianliming@gmail.com", "changeme").and_return(@user)
  end

  it "should render login form on GET to index" do
    get 'index'
    
    response.should be_success
    response.should render_template(:index)
    response.should have_tag('div#login-form > form[action=/login/login]') do
      with_tag("input[name=email]")
      with_tag("input[name=password]")      
      with_tag("input[type=submit]")
    end
  end
end
