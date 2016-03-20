require "json"

class TBA::Core::Message::Initialize
  JSON.mapping({
    version: Int32,
    uuid: String
  })
end
