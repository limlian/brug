class AddUserFriends < ActiveRecord::Migration
  def self.up
    create_table :user_friends, :id => false do |t|
      t.column :user_id, :integer
      t.column :friend_user_id, :integer
    end

    add_index :user_friends, :user_id
  end

  def self.down
    remove_index :user_friends
    drop_table :user_friends
  end
end
