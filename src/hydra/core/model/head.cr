class Hydra::Core::Head
  getter uuid : String

  getter access_token : String
  getter server : Server
  getter channels : Array(Channel)

  def online?
    @online
  end

  def online?=(online)
    @online = online
  end

  def new_access_token
    @access_token = SecureRandom.hex
  end

  def initialize(@uuid, @server)
    @access_token = SecureRandom.hex
    @online = false
    @channels = [] of Channel
  end
end
