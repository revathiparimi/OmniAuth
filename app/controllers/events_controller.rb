class EventsController < ApplicationController
  #skip_before_action :authenticate_user!, only: [:show]
  before_action :validate_user, only: [:show] #user should be creator or invitee of the event to view events

  before_action :set_event, only: [:show, :edit, :update, :destroy]
  
  respond_to :html

  def index
    @events = Event.where(user_id: current_user.id)
    respond_with(@events)
  end

  def show
    #@user=User.where(email: current_user.email)
   # @is_admin = current_user && current_user.id == @farmer.id
    @user=current_user.email
    respond_with(@event, @user)
  end

  def new
    @event = Event.new
    respond_with(@event)
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    @event.user_id=current_user.id
    @event.save
    respond_with(@event)
  end

  def update
    @event.update(event_params)
    respond_with(@event)
  end

  def destroy
    @event.destroy
    respond_with(@event)
  end
#for wepay
  def oauth
  if !params[:code]
    return redirect_to('/')
  end

  redirect_uri = url_for(:controller => 'events', :action => 'oauth', :event_id => params[:event_id], :host => request.host_with_port)
  @event = Event.find(params[:event_id])
  begin
    @event.request_wepay_access_token(params[:code], redirect_uri)
  rescue Exception => e
    error = e.message
  end

  if error
    redirect_to @event, alert: error
  else
    redirect_to @event, notice: 'We successfully connected you to WePay!'
  end
end

def buy
  redirect_uri = url_for(:controller => 'events', :action => 'payment_success', :event_id => params[:event_id], :host => request.host_with_port)
  @event = Event.find(params[:event_id])
  begin
    @checkout = @event.create_checkout(redirect_uri, current_user.email)
  rescue Exception => e
    redirect_to @event, alert: e.message
  end
end

# GET /farmers/payment_success/1
def payment_success
  @event = Event.find(params[:event_id])
  if !params[:checkout_id]
    return redirect_to @event, alert: "Error - Checkout ID is expected"
  end
  if (params['error'] && params['error_description'])
    return redirect_to @event, alert: "Error - #{params['error_description']}"
  end
  redirect_to @event, notice: "Thanks for the payment! You should receive a confirmation email shortly."
end


  private
    def set_event
      if (params.has_key?(:token))
        if Invitation.find_by(invitation_token: params[:token]) != nil
      #@event = Event.find_by_id([params[:id],(Invitation.find_by(invitation_token: params[:id])).event_id])
      
      @event=Event.find((Invitation.find_by(invitation_token: params[:token])).event_id)
      end
      else
        @event = Event.find(params[:id])
      end
    end

    def event_params
      params.require(:event).permit(:name, :start_date_time, :end_date_time, :event_type, :location, :user_id)
    end

    def validate_user
      if !user_signed_in?
        redirect_to "/products",
        error1: "User is not logged in"
      
      elsif(params.has_key?(:token))
          if Invitation.find_by(invitation_token: params[:token])!= nil
              if (Invitation.find_by(invitation_token: params[:token])).receipt_id != current_user.id
                redirect_to "/products",
                error2: "Invalid token"
              end
              
          end
      elsif Event.where(:id => params[:id]).empty?
        redirect_to "/products",
        error3: "Event is not there"
      elsif current_user.id!= (Event.find(params[:id])).user_id 
        if Invitation.where(:event_id => params[:id]).empty?
          redirect_to "/products",
          error6: "u can't access this event3"
        else
     
          if !((Invitation.where(:event_id => params[:id])).pluck(:receipt_id).include? current_user.id)
            redirect_to "/products",
            error4: "u can't access this event2"
        #return
          end
      
        end
      else
      end
     
     
        
        

      end

    
end
