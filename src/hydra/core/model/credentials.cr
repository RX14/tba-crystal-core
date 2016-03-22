class Hydra::Core::Credentials
  getter user : User
  getter channel : Channel

  property privilidged : Bool

  def initialize(@user, @channel)
    @privilidged = false
  end
end
