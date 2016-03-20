class TBA::Core::Head
  getter uuid : String

  getter server : Server
  getter channels : Array(Channel)

  def online?
    @online
  end

  def online?=(online)
    @online = online
  end

  def initialize(@uuid, @server)
    @online = false
    @channels = [] of Channel
  end
end
