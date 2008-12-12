require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FriendInvitationMessage do
  before(:each) do
    @valid_attributes = {
      :to_user_id => 1,
      :from_user_id => 2,
      :status => "pending"
    }
  end

  after(:each) do
    FriendInvitationMessage.delete_all
  end

  it "should create a new instance given valid attributes" do
    FriendInvitationMessage.create!(@valid_attributes)
  end

  it "should not create a new instance if no to user id specified" do
    @valid_attributes[:to_user_id] = nil
    lambda {FriendInvitationMessage.create!(@valid_attributes)}.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: To user is required")
  end

  it "should not create a new instance if no from user id specified" do
    @valid_attributes[:from_user_id] = nil
    lambda {FriendInvitationMessage.create!(@valid_attributes)}.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: From user is required")
  end

  it "should not create a new instance if no status specified" do
    @valid_attributes[:status] = nil
    lambda {FriendInvitationMessage.create!(@valid_attributes)}.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Status is required")
  end

  it "should not have unique to_user_id and from_user_id combination" do
    FriendInvitationMessage.create!(@valid_attributes)
    lambda {FriendInvitationMessage.create!(@valid_attributes)}.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: From user should have unique friend invitation message to one to user")
  end

end
