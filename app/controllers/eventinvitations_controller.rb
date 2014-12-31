class EventinvitationsController < ApplicationController
@@event_id
	def index
    #@event_id = params[:id]
	end
def new
    #@eventinvitation = Invitation.new
    @@event_id = params[:id]
    
    #respond_with(@eventinvitation)
  end

  def create
  	@invitation = Invitation.new(invitation_params)
    #@invitation = Invitation.new(:event_id => params[:id])
  	@invitation.save
    Invitation.mail(find_or_create(params[:email]),@invitation)
    #binding.pry
    redirect_to "/events"
  end

  private
  def invitation_params
  	sender_id=current_user.id
  	email=params[:email]
  	#receipt_id = (find_or_create(email)).id
    invited_member=find_or_create(email)
    receipt_id = invited_member.id
    #Invitation.mail(invited_member)
  	#event_id = params[:id]
  	#invitation_sent_at = Time.now
      #params.require(:invitation).permit(:email)
      #{sender_id: sender_id, receipt_id: receipt_id, event_id: event_id,invitation_sent_at: Time.now }
      #params.merge(sender_id: sender_id, receipt_id: receipt_id, event_id: event_id,invitation_sent_at: Time.now )
    params = ActionController::Parameters.new(sender_id: sender_id, receipt_id: receipt_id, event_id: @@event_id,invitation_sent_at: Time.now )
    params.permit!
    end

    def find_or_create(email)
    	u=User.where(email: email).first_or_create do |user|
        user.email = email
        user.password=Devise.friendly_token[0,20]
      end
    end

end
