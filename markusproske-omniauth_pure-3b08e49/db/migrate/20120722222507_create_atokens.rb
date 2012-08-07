class CreateAtokens < ActiveRecord::Migration
  def self.up
    create_table :atokens do |t|
	t.integer :user_id
	t.string :provider
	t.string :a_token

      t.timestamps
    end
  end

  def self.down
    drop_table :atokens
  end
end
