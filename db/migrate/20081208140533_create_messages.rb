class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :type
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :title
      t.string :body
      t.string :status
      t.timestamps
    end

    add_index :messages, :to_user_id
    add_index :messages, :status
  end

  def self.down
    remove_index :messages
    drop_table :messages
  end
end
