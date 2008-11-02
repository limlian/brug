class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false, :limit => 16
      t.string :email, :null => false, :limit => 48
      t.string :passwd_hash, :limit => 40
      t.string :passwd_salt, :limit => 40
      t.string :fname, :null => false, :limit => 32
      t.string :lname, :null => false, :limit => 32
      t.timestamps
    end

    add_index :users, :email, :unique => true
    add_index :users, :username, :unique => true
  end

  def self.down
    drop_table :users
  end
end
