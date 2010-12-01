class CreateTickspots < ActiveRecord::Migration
  def self.up
    create_table :tickspots do |t|
      t.string :login
      t.string :password
      t.timestamps
    end
  end

  def self.down
    drop_table :tickspots
  end
end
