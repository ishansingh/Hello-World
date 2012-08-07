class CreateOldTwits < ActiveRecord::Migration
  def self.up
    create_table :old_twits do |t|
      t.string :name
      t.string :tdata

      t.timestamps
    end
  end

  def self.down
    drop_table :old_twits
  end
end
