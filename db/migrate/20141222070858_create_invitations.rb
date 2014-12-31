class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :sender_id
      t.integer :receipt_id
      t.integer :event_id
      t.string :invitation_token
      t.datetime :invitation_sent_at
      t.datetime :invitation_accepted_at

      t.timestamps
    end
  end
end
