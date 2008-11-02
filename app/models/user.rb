require 'digest/sha1'

class User < ActiveRecord::Base
  
  validates_presence_of :username, :message => 'is required'
  validates_uniqueness_of :username, :message => 'has been used'
  validates_presence_of :email, :message => 'is required'
  validates_uniqueness_of :email, :message => 'has been used'
  validates_format_of :email, 
     :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
     :message => 'is invlid'
  validates_presence_of :password, :message => 'is required'
  
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

  private

  def self.salt
    Digest::SHA1.hexdigest(rand.to_s)
  end

  def self.hash_password(passwd, salt)
    Digest::SHA1.hexdigest(passwd + salt)
  end
end
