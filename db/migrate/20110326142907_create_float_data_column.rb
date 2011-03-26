class CreateFloatDataColumn < ActiveRecord::Migration
  def self.up
    add_column :tweets, :float_data, :float
    if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "postgresql"
      execute "update tweets set float_data = cast(data as float) where data similar to '^[.0-9]+$'"
    else
      execute "update tweets set float_data = cast(data as float)"
    end
  end

  def self.down
    remove_column :tweets, :float_data
  end
end