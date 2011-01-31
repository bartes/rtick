class CreateRedmines < ActiveRecord::Migration
  def self.up
    create_table :redmines do |t|
      t.string :login
      t.string :password
      t.string :job
      t.string :project
      t.timestamps
    end
  end

  def self.down
    drop_table :redmines
  end
end

