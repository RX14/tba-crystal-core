require "secure_random"
require "./core/**"

module TBA::Core
  @@servers = {} of String => Server
  @@heads = {} of String => Head
  @@channels = {} of String => Channel
  @@users = {} of String => User

  def self.run
    esper = new_server "esper"
    head = new_head esper
    puts head.uuid
    HeadServer.start
    sleep
  end

  def self.new_server(name)
    server = Server.new(SecureRandom.uuid, name)
    @@servers[server.uuid] = server
    server
  end

  def self.get_server?(uuid)
    @@servers[uuid]?
  end

  def self.get_server(uuid)
    @@servers[uuid]
  end

  def self.remove_server(uuid)
    server = @@servers.delete(uuid)
    server.channels.dup.each { |c| remove_channel c }
    server.heads.dup.each { |h| remove_head h }
    nil
  end

  def self.new_head(server)
    head = Head.new(SecureRandom.uuid, server)
    @@heads[head.uuid] = head
    server.heads << head
    head
  end

  def self.get_head?(uuid)
    @@heads[uuid]?
  end

  def self.get_head(uuid)
    @@heads[uuid]
  end

  def self.remove_head(uuid)
    head = @@heads.delete(uuid)
    head.server.delete head
    nil
  end

  def self.new_channel(name, server)
    channel = Channel.new(SecureRandom.uuid, name, server)
    @@channels[channel.uuid] = channel
    server.channels << channel
    channel
  end

  def self.get_channel?(uuid)
    @@channels[uuid]?
  end

  def self.get_channel(uuid)
    @@channels[uuid]
  end

  def self.remove_channel(uuid)
    channel = @@channels.delete(uuid)
    channel.server.delete channel
    nil
  end

  def self.new_user(nickname)
    user = User.new(SecureRandom.uuid, nickname)
    @@users[user.uuid] = user
    user
  end

  def self.get_user?(uuid)
    @@users[uuid]?
  end

  def self.get_user(uuid)
    @@users[uuid]
  end

  def self.remove_user(uuid)
    user = @@users.delete(uuid)
    @@channels.each_value do |chan|
      chan.users.delete user
      chan.privilidges.delete user
    end
  end

  macro map_getter(type)
    def self.get_{{type}}?(uuid)
      @@{{type}}s[uuid]?
    end

    def self.get_{{type}}(uuid)
      @@{{type}}s[uuid]
    end
  end
end

TBA::Core.run

