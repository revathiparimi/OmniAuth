class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_create :send_mail
  has_many :authentications
  has_many :invitations, :class_name => self.to_s, :as => :invited_by
  has_many :events
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
        :omniauthable, :omniauth_providers => [:facebook]
 def self.from_user(auth)
      where(email: auth.info.email).first_or_create do |user|
        
        user.email = auth.info.email
        user.name = auth.info.name
        user.password=Devise.friendly_token[0,20]
      end
  end
   
   def send_mail
    @user=User.last
    UserNotifier.send_signup_email(@user).deliver
   end

   
end
