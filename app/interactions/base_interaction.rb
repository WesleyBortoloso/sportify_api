class BaseInteraction
  attr_accessor :params, :headers, :current_user

  def self.call(params, current_user: nil, headers: nil)
    new(params, current_user: current_user, headers: headers).call
  end

  def initialize(params, current_user: nil, headers: nil)
    @current_user = current_user
    @headers = headers
    @params = params
  end
end
