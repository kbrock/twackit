class CreateImports < ActiveRecord::Migration
  def self.up
    create_table :imports do |t|
      t.integer :tweets
      t.integer :distinct_users
      t.integer :errs
      t.integer :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :imports
  end
end
