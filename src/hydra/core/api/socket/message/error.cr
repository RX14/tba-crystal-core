class Hydra::Core::API::Socket::Message::Error < Exception
  ERROR_TYPES = {
    internal: {1, "Internal server error"},
    malformed_message: {2, "Message could not be parsed"},
    invalid_command: {3, "Invalid command sent"},
    malformed_json: {4, "JSON could not be parsed"},
    no_initialize: {5, "No initialize message sent"},
    invalid_head_uuid: {6, "Invalid head UUID"}
  }

  def initialize(error_key)
    error_type = ERROR_TYPES[error_key]

    super error_type[1]
    @code = error_type[0]
  end

  def to_json(io : IO)
    io.json_object do |json|
      json.field "type" do
        "type".to_json(io)
      end

      json.field "message" do
        @message.to_json(io)
      end

      json.field "code" do
        @code.to_json(io)
      end
    end
  end
end
