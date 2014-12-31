class Event < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :name, :start_date_time

	def wepay_authorization_url(redirect_uri, user_email)
  GemsUsage::Application::WEPAY.oauth2_authorize_url(redirect_uri, user_email, self.name)
  end

# takes a code returned by wepay oauth2 authorization and makes an api call to generate oauth2 token for this farmer.
 def request_wepay_access_token(code, redirect_uri)
  response = GemsUsage::Application::WEPAY.oauth2_token(code, redirect_uri)
  if response['error']
    raise "Error - "+ response['error_description']
  elsif !response['access_token']
    raise "Error requesting access from WePay"
  else
    self.wepay_access_token = response['access_token']
    self.save

    self.create_wepay_account
  end
 end

 def has_wepay_access_token?
  !self.wepay_access_token.nil?
 end

# makes an api call to WePay to check if current access token for farmer is still valid
def has_valid_wepay_access_token?
  if self.wepay_access_token.nil?
    return false
  end
  response = GemsUsage::Application::WEPAY.call("/user", self.wepay_access_token)
  response && response["user_id"] ? true : false
end

def has_wepay_account?
  self.wepay_account_id != 0 && !self.wepay_account_id.nil?
end

# creates a WePay account for this farmer with the farm's name
def create_wepay_account
  if self.has_wepay_access_token? && !self.has_wepay_account?
    params = { :name => self.name, :description => "Event - " + self.name }			
    response = GemsUsage::Application::WEPAY.call("/account/create", self.wepay_access_token, params)

    if response["account_id"]
      self.wepay_account_id = response["account_id"]
      return self.save
    else
      raise "Error - " + response["error_description"]
    end

  end		
  raise "Error - cannot create WePay account"
end

def create_checkout(redirect_uri,email)
  # calculate app_fee as 10% of produce price
  app_fee = 20
  event_fee=100

  params = {
    :account_id => self.wepay_account_id,
    :short_description => "Produce sold by #{email}",
    :type => :GOODS,
    :amount => event_fee,			
    :app_fee => app_fee,
    :fee_payer => :payee,			
    :mode => :iframe,
    :redirect_uri => redirect_uri
  }
  response = GemsUsage::Application::WEPAY.call('/checkout/create', self.wepay_access_token, params)

  if !response
    raise "Error - no response from WePay"
  elsif response['error']
    raise "Error - " + response["error_description"]
  end

  return response
end
end
