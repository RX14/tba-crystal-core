class TBA::Core::Channel
  getter uuid : String

  property name : String
  getter server : Server
  getter users : Array(User)
  getter privilidges : Hash(User, Credentials)

  def initialize(@uuid, @name, @server)
    @users = [] of User
    @privilidges = {} of User => Credentials
  end
end
