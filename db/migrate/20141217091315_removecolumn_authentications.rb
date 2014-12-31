class RemovecolumnAuthentications < ActiveRecord::Migration
  def change
  	remove_column :authentications, :name
  end
end
