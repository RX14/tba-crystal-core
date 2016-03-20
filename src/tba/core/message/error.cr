class TBA::Core::Message::Error < Exception
  ERROR_TYPES = {
    internal: {1, "Internal server error"},
    no_type: {2, "No type key on message"},
    no_initialize: {3, "No initialize message sent"},
    invalid_head_uuid: {4, "Invalid head UUID"}
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
