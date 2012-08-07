class OldTwitterData < ActiveRecord::Migration
  def self.up
    create_table :oldtwitterdata do |t|
      t.string :name
      t.string :tdata

      t.timestamps
    end
  end

  def self.down
    drop_table :oldtwitterdata
  end
end
