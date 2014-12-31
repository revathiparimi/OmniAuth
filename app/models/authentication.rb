class Authentication < ActiveRecord::Base
	belongs_to :user
	def self.from_omniauth(auth,userobject)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
      user.user_id=userobject.id
        #user.user_id
      end
  end
end
