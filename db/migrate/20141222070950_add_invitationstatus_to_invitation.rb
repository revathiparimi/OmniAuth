class AddInvitationstatusToInvitation < ActiveRecord::Migration
  def change
  	add_column :invitations, :invitation_status, :string, :default => "Pending"
  end
end
