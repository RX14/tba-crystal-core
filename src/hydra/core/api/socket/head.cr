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

  private def self.connection_impl(io)
    type, message = read io
    err :no_initialize unless type == "INIT"

    begin
      init_msg = Message::Initialize.from_json message
    rescue
      err :malformed_json
    end

    head = Core.get_head?(init_msg.uuid) || err :invalid_head_uuid

    loop do
      type, message = read io
      case type
      when ""
      else
        err :invalid_command
      end
    end
  end

  private def self.read(io) : {String, String}
    type = read_type io
    p 3
    rest = io.gets "\r\n"
    p 4

    err :malformed_message if rest.nil?

    return type, rest.not_nil!
  end

  private def self.read_type(io) : String
    p 1
    type = io.gets(' ', 15)
    p 2

    err :malformed_message if type.nil?
    type = type.not_nil!
    err :malformed_message if type[-1] != ' '

    type[(0...-1)]
  end

  macro err(type)
    raise Message::Error.new({{type}})
  end
end
