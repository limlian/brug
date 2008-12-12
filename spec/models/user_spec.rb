require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    User.delete_all
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
    @valid_attributes[:email] = "demo"
    lambda { User.create!(@valid_attributes) }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email is invlid")

    @valid_attributes[:email] = "demo@"
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
    user = User.authenticate('demo@brug.org', 'changeme')
    user.should_not be_nil

    user = User.authenticate('demo@brug.org', 'changeyou')
    user.should be_nil
    
    user = User.authenticate('', 'changeme')
    user.should be_nil

    user = User.authenticate('demo@brug.org', '')
    user.should be_nil

    user = User.authenticate('', '')
    user.should be_nil
  end

  it "should correctly delete an user" do
    User.create!(@valid_attributes)
    
    user = User.find_by_email('demo@brug.org')
    user.should_not be_nil

    user.destroy

    user = User.find_by_email('demo@brug.org')
    user.should be_nil
  end

  it "should raise error when have different password_confirmation" do
    @valid_attributes[:password_confirmation] = "changeyou"
    lambda { User.create!(@valid_attributes) }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Password should match")
  end
end

describe User, "with fixtures loaded" do
  fixtures :users

  after(:each) do
    # User.delete_all
  end

  it "should tell correct numbers of users defined in fixtures" do
    User.should have(5).records
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

describe User, "friends with fixtures loaded" do
  fixtures :users

  after(:each) do
  end

  it "should tell correct numbers of users defined in fixtures" do
    User.should have(5).records
  end

  it "should tell correctly if one is another's friend" do
    user_demo1 = User.find_by_email('demo1@example.com')
    user_demo2 = User.find_by_email('demo2@example.com')
    user_demo3 = User.find_by_email('demo3@example.com')

    user_demo1.friends.empty?.should be_false
    user_demo2.friends.empty?.should be_false
    user_demo3.friends.empty?.should be_false

    user_demo1.is_my_friend?(user_demo2).should be_true
    user_demo1.is_my_friend?(user_demo3).should be_false

    user_demo2.is_my_friend?(user_demo1).should be_true
    user_demo2.is_my_friend?(user_demo3).should be_true

    user_demo3.is_my_friend?(user_demo2).should be_true
    user_demo3.is_my_friend?(user_demo1).should be_false
  end

  it " myself can't be my friend" do
    user_demo1 = User.find_by_email('demo1@example.com')
    user_demo1.is_my_friend?(user_demo1).should be_false

    user_demo1.add_friend user_demo1
    user_demo1.is_my_friend?(user_demo1).should be_false

    user_demo1_1 = User.find_by_email('demo1@example.com')
    user_demo1_1.is_my_friend?(user_demo1).should be_false

    user_demo1_1.add_friend user_demo1
    user_demo1_1.is_my_friend?(user_demo1).should be_false
  end

  it "should allow user add a new friend" do
    user_demo1 = User.find_by_email('demo1@example.com')
    user_demo3 = User.find_by_email('demo3@example.com')

    user_demo1.is_my_friend?(user_demo3).should be_false
    user_demo3.is_my_friend?(user_demo1).should be_false

    user_demo1.add_friend user_demo3

    user_demo1.is_my_friend?(user_demo3).should be_true
    user_demo3.is_my_friend?(user_demo1).should be_true
  end

  it "should allow user delete an existed friend" do
    user_demo1 = User.find_by_email('demo1@example.com')
    user_demo2 = User.find_by_email('demo2@example.com')

    user_demo1.is_my_friend?(user_demo2).should be_true
    user_demo2.is_my_friend?(user_demo1).should be_true

    user_demo1.has_friends?.should be_true
    
    user_demo1.remove_friend user_demo2

    user_demo1.is_my_friend?(user_demo2).should be_false
    user_demo2.is_my_friend?(user_demo1).should be_false

    user_demo1.has_friends?.should be_false
  end

  it "allow to remove all friends" do
    user_demo1 = User.find_by_email('demo1@example.com')
    user_demo2 = User.find_by_email('demo2@example.com')
    user_demo3 = User.find_by_email('demo3@example.com')

    user_demo1.add_friend user_demo3

    user_demo2.has_friends?.should be_true
    user_demo1.is_my_friend?(user_demo3).should be_true
    user_demo3.is_my_friend?(user_demo1).should be_true
    
    user_demo2.remove_all_friends

    user_demo2.has_friends?.should be_false
    user_demo1.is_my_friend?(user_demo3).should be_true
    user_demo3.is_my_friend?(user_demo1).should be_true
  end
end
