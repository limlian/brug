require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MessagesController do

  #Delete this example and add some real ones
  it "should use MessagesController" do
    controller.should be_an_instance_of(MessagesController)
  end

  it "shoule have correct routes" do
    params_from(:get, "/users/1/messages").should == {:controller => "messages", :action => "index", :user_id => "1"}
    params_from(:post, "/users/1/messages").should == {:controller => "messages", :action => "create", :user_id => "1"}
  end
end

describe MessagesController do
  before(:each) do
    @owner = mock_model(User)
    @viewer = mock_model(User)
    @owner.stub!(:is_my_friend?).with(@viewer).and_return(false)
    @friend_invitation_message = mock_model(FriendInvitationMessage)
  end

  it "should add a friend inivitation to an existed user" do
    User.should_receive(:find_by_id).with(2).and_return(@viewer)
    User.should_receive(:find_by_id).with("2").and_return(@viewer)
    User.should_receive(:find_by_id).with("1").and_return(@owner)
    @owner.should_receive(:is_my_friend?).with(@viewer).and_return(false)
    FriendInvitationMessage.should_receive(:find_or_initialize_by_from_user_id_and_to_user_id).with(@viewer.id, @owner.id).and_return(@friend_invitation_message)
    @friend_invitation_message.should_receive(:status=).with("pending")
    @friend_invitation_message.should_receive(:save).and_return(true)

    session[:user_id] = 2
    post "create", {:user_id => 1, :invitation_user_id => 2, :message_type => "friend_invitation", :status => "pending"}
    
    flash[:notice].should == "Friend invitation sent!"
    response.should redirect_to(user_url(@owner))
  end
end

describe "/users/1/messages" do
  controller_name :messages
  integrate_views

  before(:each) do
  end

  it "should log in to view user message page" do
    session[:user_id] = nil
    get 'index', :id => 1
    response.should redirect_to(:controller => "login")
  end
end

describe MessagesController, "display friend invitation messages" do
  integrate_views

  before(:each) do
    @user1 = mock_model(User)
    @user2 = mock_model(User)
    @friend_invitation_message = mock_model(FriendInvitationMessage)
    @user1.stub!(:messages).and_return([@friend_invitation_message])

  end

  it "should display a pending friend invitation messages if got" do
    User.should_receive(:find_by_id).with(1).and_return(@user1)
    @user1.should_receive(:received_messages).and_return([@friend_invitation_message])
    @friend_invitation_message.should_receive(:type).and_return("FriendInvitationMessage")
    @friend_invitation_message.should_receive(:status).and_return("pending")
    @friend_invitation_message.should_receive(:to_user).at_least(:once).and_return(@user1)
    @user1.should_receive(:id).and_return(1)
    @friend_invitation_message.should_receive(:from_user).at_least(:once).and_return(@user2)
    @user2.should_receive(:fname).and_return("demo2")
    @user2.should_receive(:lname).and_return("demo2")
    @user2.should_receive(:id).and_return(2)

    session[:user_id] = 1
    get 'index'
    
    response.should include_text("demo2 demo2 invites you as friend")
    
    response.should have_tag("form") do
      with_tag("input[name=friend_user_id][value=1]")
      with_tag("input[type=submit][value='Accept']")
    end

    response.should have_tag("form") do
      with_tag("input[name=invitation_user_id][type=hidden][value=2]")
      with_tag("input[name=message_type][type=hidden][value=friend_invitation]")
      with_tag("input[name=status][type=hidden][value=deny]")
      with_tag("input[type=submit][value='Deny']")
    end
  end

  it "should display a deny friend invitation messages if got" do
  end
end
