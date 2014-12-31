class UserNotifier < ActionMailer::Base
  default from: "from@example.com"
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Thanks for signing up for our app' )
  end

  def send_invitation_email(user,invitationobject)
    @user = user
    @invitation=invitationobject
    mail( :to => @user.email,
    :subject => 'you got an invitation' )
  end
end
