require "json"

class Hydra::Core::API::Socket::Message::Initialize
  JSON.mapping({
    version: Int32,
    uuid: String
  })
end
