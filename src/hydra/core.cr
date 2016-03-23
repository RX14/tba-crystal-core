require "secure_random"
require "./core/**"

module Hydra::Core
  @@servers = {} of String => Server
  @@heads = {} of String => Head
  @@channels = {} of String => Channel
  @@users = {} of String => User

  def self.run
    spawn { API::HTTP.run }
    spawn { API::Socket::Head.run }
    sleep
  end

  def self.servers
    @@servers.not_nil!
  end

  def self.new_server(name : String)
    server = Server.new(SecureRandom.uuid, name)
    servers[server.uuid] = server
    server
  end

  def self.get_server?(uuid : String)
    servers[uuid]?
  end

  def self.get_server(uuid : String)
    servers[uuid]
  end

  def self.remove_server(uuid : String)
    server = servers.delete(uuid).not_nil!
    server.channels.dup.each { |c| remove_channel c }
    server.heads.dup.each { |h| remove_head h }
    nil
  end

  def self.remove_server(server : Server)
    remove_server server.uuid
  end

  def self.heads
    @@heads.not_nil!
  end

  def self.new_head(server)
    head = Head.new(SecureRandom.uuid, server)
    heads[head.uuid] = head
    server.heads << head
    head
  end

  def self.get_head?(uuid : String)
    heads[uuid]?
  end

  def self.get_head(uuid : String)
    heads[uuid]
  end

  def self.remove_head(uuid : String)
    head = heads.delete(uuid).not_nil!
    head.server.heads.delete head
    nil
  end

  def self.remove_head(head : Head)
    remove_head head.uuid
  end

  def self.channels
    @@channels.not_nil!
  end

  def self.new_channel(name, server)
    channel = Channel.new(SecureRandom.uuid, name, server)
    channels[channel.uuid] = channel
    server.channels << channel
    channel
  end

  def self.get_channel?(uuid : String)
    channels[uuid]?
  end

  def self.get_channel(uuid : String)
    channels[uuid]
  end

  def self.remove_channel(uuid : String)
    channel = channels.delete(uuid).not_nil!
    channel.server.channels.delete channel
    nil
  end

  def self.remove_channel(channel : Channel)
    remove_channel channel.uuid
  end

  def self.users
    @@users.not_nil!
  end

  def self.new_user(nickname : String)
    user = User.new(SecureRandom.uuid, nickname)
    users[user.uuid] = user
    user
  end

  def self.get_user?(uuid : String)
    users[uuid]?
  end

  def self.get_user(uuid : String)
    users[uuid]
  end

  def self.remove_user(uuid : String)
    user = users.delete(uuid).not_nil!
    channels.each_value do |chan|
      chan.users.delete user
      chan.privilidges.delete user
    end
  end

  def self.remove_user(user : User)
    remove_user user.uuid
  end
end
