class CreateRubytimes < ActiveRecord::Migration
  def self.up
    create_table :rubytimes do |t|
      t.string :login
      t.string :password
      t.integer :project_id
      t.timestamps
    end
  end

  def self.down
    drop_table :rubytimes
  end
end
