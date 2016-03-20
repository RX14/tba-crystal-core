class Hydra::Core::Server
  getter uuid : String

  property name : String
  getter channels : Array(Channel)
  getter heads : Array(Head)

  def initialize(@uuid, @name)
    @channels = [] of Channel
    @heads = [] of Head
  end
end
