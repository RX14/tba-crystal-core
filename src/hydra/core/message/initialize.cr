require "json"

class Hydra::Core::Message::Initialize
  JSON.mapping({
    version: Int32,
    uuid: String
  })
end
