require 'digest/sha1'

class User < ActiveRecord::Base

  has_and_belongs_to_many :friends,
    :join_table => "user_friends",
    :foreign_key => "user_id",
    :association_foreign_key => "friend_user_id",
    :class_name => "User",
    :after_add => :add_friend_to_other,
    :after_remove => :remove_friend_from_other
  
  has_many :received_messages, :class_name => "Message", :foreign_key => "to_user_id"
  has_many :sent_messages, :class_name => "Message", :foreign_key => "from_user_id"
  
  validates_presence_of :username, :message => 'is required'
  validates_uniqueness_of :username, :message => 'has been used'
  validates_presence_of :email, :message => 'is required'
  validates_uniqueness_of :email, :message => 'has been used'
  validates_format_of :email, 
     :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
     :message => 'is invlid'
  validates_presence_of :password, :message => 'is required'
  validates_confirmation_of :password, :message => 'should match'
  
  def self.authenticate(email, passwd)
    user = User.find_by_email(email);
    
    if user
      if user.passwd_hash != User.hash_password(passwd, user.passwd_salt)
        user = nil
      end
    end
    
    user
  end
  
  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    self.passwd_salt = User.salt
    self.passwd_hash = User.hash_password(pwd, self.passwd_salt)
  end

  def add_friend(friend_user)
    self.friends << friend_user unless friend_user == self
  end

  def remove_friend(friend_user)
    self.friends.delete(friend_user)
  end

  def remove_all_friends
    self.friends.clear
  end

  def is_my_friend?(friend_user)
    self.friends.exists? friend_user
  end

  def has_friends?
    self.friends.empty? ? false : true
  end

  def is_invited_as_friend_by?(another_user)
    FriendInvitationMessage.find(:first, :conditions => 
        {:to_user_id => self.id, 
         :from_user_id => another_user.id, 
         :status => "pending" 
        }).nil? ? false : true
  end

  def invites_friend_to?(another_user)
    FriendInvitationMessage.find(:first, :conditions => 
        {:to_user_id => another_user.id, 
         :from_user_id => self.id,
         :status => "pending" 
        }).nil? ? false : true
  end

  def self.salt
    Digest::SHA1.hexdigest(rand.to_s)
  end

  def self.hash_password(passwd, salt)
    Digest::SHA1.hexdigest(passwd + salt)
  end

  protected

  def add_friend_to_other(other)
    other.friends << self unless other.friends.include?(self)
  end

  def remove_friend_from_other(other)
    other.friends.delete(self) if other.friends.include?(self)
  end
end
