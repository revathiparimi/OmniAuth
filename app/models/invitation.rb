class Invitation < ActiveRecord::Base
	#after_create :send_mail
	 before_create :generate_token

	def self.mail(invited_member,invitationobject)
		@user = invited_member
		@invitation=invitationobject
		UserNotifier.send_invitation_email(@user,@invitation).deliver
	end

private
  def generate_token
    self.invitation_token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
    
end
