class AddcolumnstoEvents < ActiveRecord::Migration
  def change
  	add_column :events, :wepay_access_token, :string
    add_column :events, :wepay_account_id, :integer
  end
end
