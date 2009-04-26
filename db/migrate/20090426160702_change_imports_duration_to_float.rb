class ChangeImportsDurationToFloat < ActiveRecord::Migration
  def self.up
    change_column :imports, :duration, :float
  end

  def self.down
    change_column :imports, :duration, :integer
  end
end
