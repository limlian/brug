class Message < ActiveRecord::Base
  belongs_to :to_user, :class_name => "User", :foreign_key => "to_user_id"
  belongs_to :from_user, :class_name => "User", :foreign_key => "from_user_id"
  validates_presence_of :to_user_id, :message => 'is required'
end
