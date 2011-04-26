class CreateFloatDataColumn < ActiveRecord::Migration
  def self.up
    # if it is non numeric data, have it be null (being explicit here)
    add_column :tweets, :float_data, :float, :null => true

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