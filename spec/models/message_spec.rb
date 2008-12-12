require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do
  before(:each) do
    @valid_attributes = {
      :to_user_id => 1
    }
  end
  
  after(:each) do
    Message.delete_all
  end
  
  it "should create a new instance given valid attributes" do
    Message.create!(@valid_attributes)
  end

  it "should not create a new instance given invalid attributes" do
    @valid_attributes[:to_user_id] = nil
    lambda { Message.create!(@valid_attributes)}.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: To user is required")
  end
end

describe Message, "with fixtures loaded" do
  fixtures :users, :messages

  before(:each) do
    @user_demo1 = User.find_by_email('demo1@example.com')
    @user_demo2 = User.find_by_email('demo2@example.com')
    @user_demo3 = User.find_by_email('demo3@example.com')
  end

  it "should return correct received messages" do
    @user_demo1.is_my_friend?(@user_demo3).should be_false
    @user_demo3.received_messages.size.should == 1
    message = @user_demo3.received_messages[0]
    message.instance_of?(Message).should be_false
    message.kind_of?(Message).should be_true
    message.instance_of?(FriendInvitationMessage).should be_true
    message.status.should == "pending"

    @user_demo3.is_invited_as_friend_by?(@user_demo1).should be_true
    @user_demo2.is_invited_as_friend_by?(@user_demo1).should be_false
  end

  it "should return correct sent messages" do
    @user_demo1.is_my_friend?(@user_demo3).should be_false
    @user_demo1.sent_messages.size.should == 1
    message = @user_demo1.sent_messages[0]
    message.instance_of?(Message).should be_false
    message.kind_of?(Message).should be_true
    message.instance_of?(FriendInvitationMessage).should be_true
    message.status.should == "pending"

    @user_demo1.invites_friend_to?(@user_demo3).should be_true
    @user_demo2.invites_friend_to?(@user_demo1).should be_false
  end
end
