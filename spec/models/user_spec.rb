require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :username => 'demo',
      :fname => 'demo',
      :lname => 'demo',
      :email => 'demo@brug.org',
      :password => 'changeme'
    }
  end

  after(:each) do
    User.delete_all
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

  it "should not create a new use if providing nil username" do
    @valid_attributes[:username] = nil
    lambda { User.create!(@valid_attributes) }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Username is required")
  end

  it "should not create a new use if providing nil email" do
    @valid_attributes[:email] = nil
    lambda { User.create!(@valid_attributes) }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email is required, Email is invlid")
  end

  it "should reject incorrect formats of email" do 
    @valid_attributes[:email] = "admin"
    lambda { User.create!(@valid_attributes) }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email is invlid")

    @valid_attributes[:email] = "admin@"
    lambda { User.create!(@valid_attributes) }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email is invlid")

    @valid_attributes[:email] = "@brug.org"
    lambda { User.create!(@valid_attributes) }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email is invlid")
  end

  it "should not create a new use if providing nil password" do
    @valid_attributes[:password] = nil
    lambda { User.create!(@valid_attributes) }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Password is required")
  end

  it "should authenticate with correct admin user password" do
    User.create!(@valid_attributes)
    user = User.authenticate('admin@brug.org', 'changeme')
    user.should_not be_nil

    user = User.authenticate('admin@brug.org', 'changeyou')
    user.should be_nil
    
    user = User.authenticate('', 'changeme')
    user.should be_nil

    user = User.authenticate('admin@brug.org', '')
    user.should be_nil

    user = User.authenticate('', '')
    user.should be_nil
  end
end

describe User, "with fixtures loaded" do
  fixtures :users

  it "should tell correct numbers of users defined in fixtures" do
    User.should have(2).records
  end

  it "should report error when add user with existed username" do
    lambda {
      User.create!(
         :username => 'admin',
         :email => 'unique@brug.org',
         :password => 'changeme',
         :fname => 'admin',
         :lname => 'brug'
      )                     
    }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Username has been used")
  end

  it "should report error when add user with existed email" do
    lambda {
      User.create!(
         :username => 'unique',
         :email => 'admin@brug.org',
         :password => 'changeme',
         :fname => 'admin',
         :lname => 'brug'
      )                     
    }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email has been used")
  end
end
