require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FriendsController do

  #Delete this example and add some real ones
  it "should use FriendsController" do
    controller.should be_an_instance_of(FriendsController)
  end

  it "should have correct routes" do
    params_from(:get, "/users/1/friends").should == {:controller => "friends", :action => "index", :user_id => "1"}
    params_from(:post, "/users/1/friends").should == {:controller => "friends", :action => "create", :user_id => "1"}
    params_from(:delete, "/users/1/friends/99").should == 
      {:controller => "friends", :action => "destroy", :user_id => "1", :id => "99"}
  end
end

describe FriendsController do
  before(:each) do
    @user1 = mock("user")
    @user2 = mock("user")
    @user3 = mock("user")

    @user1.stub!(:friends).and_return([@user2]) 
    @user2.stub!(:friends).and_return([@user1, @user3])
    @user3.stub!(:friends).and_return([@user2])
  end

  it "should add a friend to an existed user" do
    User.should_receive(:find).with("1").and_return(@user1)
    User.should_receive(:find).with("3").and_return(@user3)
    @user1.should_receive(:add_friend).with(@user3)
    @user1.should_receive(:id).and_return(1)
    post "create", {:user_id => 1, :friend_user_id => 3}
    response.should redirect_to(:controller => 'users', :action => 'show', :id => 1)
  end

  it "should delete a friend from an existed user" do
    User.should_receive(:find).with("1").and_return(@user1)
    User.should_receive(:find).with("2").and_return(@user2)
    @user1.should_receive(:remove_friend).with(@user2)
    delete "destroy", {:user_id => 1, :friend_user_id => 2}    
  end
end
