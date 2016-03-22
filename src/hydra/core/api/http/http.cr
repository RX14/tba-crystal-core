require "json"
require "crouter"

class Hydra::Core::API::HTTP < Crouter::Router
  def self.run
    puts "Listening for HTTP requests on [::]:8080"
    HTTP::Server.new(8080, [HTTP::LogHandler.new, API::HTTP.new("/api/v1")]).listen
  end

  macro req
    context.request
  end

  macro res
    context.response
  end

  macro fail(err_code, msg)
    res.status_code = {{err_code}}
    res << {{msg}}
    return
  end

  post "/server" do
    fail 400, "No body" unless req.body
    json = JSON.parse req.body.not_nil!
    server = Core.new_server json["name"].as_s
    {uuid: server.uuid, name: server.name}.to_json res

    nil
  end

  post "/head" do
    fail 400, "No body" unless req.body
    json = JSON.parse req.body.not_nil!
    server = Core.get_server json["server"]["uuid"].as_s
    head = Core.new_head server
    {uuid: head.uuid, server: {uuid: server.uuid}, access_token: head.access_token}.to_json res

    nil
  end
end
