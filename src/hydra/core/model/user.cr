class Hydra::Core::User
  getter uuid : String

  property displayname : String

  def initialize(@uuid, @displayname)
  end
end
