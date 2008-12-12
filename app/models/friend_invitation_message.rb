class FriendInvitationMessage < Message
  validates_presence_of :from_user_id, :message => 'is required'
  validates_presence_of :status, :message => 'is required'
  validates_uniqueness_of :from_user_id, :scope => :to_user_id, :message => 'should have unique friend invitation message to one to user'
end
