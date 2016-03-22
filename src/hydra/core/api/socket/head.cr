require "socket"
require "json"

class Hydra::Core::API::Socket
  # The fucc
end

class Hydra::Core::API::Socket::Head
  def self.run
    server = TCPServer.new(2926)

    puts "Listening for heads on [::]:2926"
    loop do
      sock = server.accept
      # Per-Connection fiber
      spawn do
        begin
          connection_impl(sock)
        rescue err : Message::Error
          err.to_json sock
        rescue err
          # TODO: logging
          puts err.inspect
          Message::Error.new(:internal).to_json sock
        ensure
          sock.close
        end
      end
    end
  end

  private def self.connection_impl(sock)
    first_msg_raw = sock.gets
    return unless first_msg_raw

    err :no_initialize if get_type(first_msg_raw) != "initialize"
    init_msg = Message::Initialize.from_json first_msg_raw

    head = Core.get_head?(init_msg.uuid) || err :invalid_head_uuid
  end

  private def self.get_type(raw_msg) : String
    parser = JSON::PullParser.new raw_msg

    type = nil
    parser.on_key("type") do
      type = parser.read_string
    end

    err :no_type if type.nil?
    type.not_nil!
  end

  macro err(type)
    raise Message::Error.new({{type}})
  end
end
