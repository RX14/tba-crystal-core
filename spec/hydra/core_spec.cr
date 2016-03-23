require "../spec_helper"

Spec2.describe Hydra::Core do
  after do
    core.servers.clear
    core.heads.clear
    core.channels.clear
    core.users.clear
  end
  
  let(:core) { Hydra::Core }
  let(:server) { core.new_server "test server" }

  describe "#new_server" do
    it "updates the servers list" do
      assert core.servers.size == 0

      server = core.new_server "test server"

      assert core.servers.size == 1
      assert core.servers.values[0] == server
    end

    it "generates a random uuid" do
      10.times { |i| core.new_server "test server #{i}" }

      core.servers.values.each_combination(2) { |c| assert c[0].uuid != c[1].uuid }
    end

    it "sets the correct name" do
      random_string = SecureRandom.base64(100)
      server = core.new_server random_string
      assert server.name == random_string
    end
  end

  describe "#remove_server" do
    it "updates the servers list" do
      server1 = core.new_server "test server 1"
      server2 = core.new_server "test server 2"

      assert core.servers.size == 2
      assert core.servers.values[0] == server1

      core.remove_server server1

      assert core.servers.size == 1
      assert core.servers.values[0] == server2
    end

    it "deletes all child channels" do
      server = core.new_server "test server"
      channel1 = core.new_channel "test#channel1", server
      channel2 = core.new_channel "test#channel2", server

      assert core.channels.size == 2

      core.remove_server server

      assert core.channels.size == 0
    end

    it "deletes all child heads" do
      server = core.new_server "test server"
      head1 = core.new_head server
      head2 = core.new_head server

      assert core.heads.size == 2

      core.remove_server server

      assert core.heads.size == 0
    end
  end

  describe "#new_head" do
    it "updates the heads list" do
      assert core.heads.size == 0

      head = core.new_head server

      assert core.heads.size == 1
      assert core.heads.values[0] == head
    end

    it "generates a random uuid" do
      10.times { |i| core.new_head server }

      core.heads.values.each_combination(2) { |c| assert c[0].uuid != c[1].uuid }
    end

    it "sets the correct server" do
      head = core.new_head server
      assert head.server == server
    end
    
    it "adds the head to the server" do
      assert server.heads.size == 0

      head = core.new_head server

      assert server.heads.size == 1
      assert server.heads[0] == head
    end
  end

  describe "#remove_head" do
    it "updates the heads list" do
      head1 = core.new_head server
      head2 = core.new_head server

      assert core.heads.size == 2
      assert core.heads.values[0] == head1

      core.remove_head head1

      assert core.heads.size == 1
      assert core.heads.values[0] == head2
    end

    it "deletes the head from the server" do
      assert server.heads.size == 0

      head = core.new_head server

      assert server.heads.size == 1
      assert server.heads[0] == head

      core.remove_head head

      assert server.heads.size == 0
    end
  end

  describe "#new_channel" do
    it "updates the channel list" do
      assert core.channels.size == 0

      channel = core.new_channel "test channel", server

      assert core.channels.size == 1
      assert core.channels.values[0] == channel
    end

    it "generates a random uuid" do
      10.times { |i| core.new_channel "test channel #{i}", server }

      core.channels.values.each_combination(2) { |c| assert c[0].uuid != c[1].uuid }
    end

    it "sets the correct name" do
      random_string = SecureRandom.base64(100)

      channel = core.new_channel random_string, server
      assert channel.name == random_string
    end

    it "sets the correct server" do
      channel = core.new_channel "test channel", server
      assert channel.server == server
    end

    it "adds the channel to the server" do
      assert server.channels.size == 0

      channel = core.new_channel "test channel", server

      assert server.channels.size == 1
      assert server.channels[0] == channel
    end
  end

  describe "#remove_channel" do
    it "updates the channels list" do
      channel1 = core.new_channel "test channel 1", server
      channel2 = core.new_channel "test channel 2", server

      assert core.channels.size == 2
      assert core.channels.values[0] == channel1

      core.remove_channel channel1

      assert core.channels.size == 1
      assert core.channels.values[0] == channel2
    end

    it "deletes the channel from the server" do
      assert server.channels.size == 0

      channel = core.new_channel "test channel", server

      assert server.channels.size == 1
      assert server.channels[0] == channel

      core.remove_channel channel

      assert server.channels.size == 0
    end
  end

  describe "#new_user" do
    it "updates the users list" do
      assert core.users.size == 0

      user = core.new_user "test user"

      assert core.users.size == 1
      assert core.users.values[0] == user
    end

    it "generates a random uuid" do
      10.times { |i| core.new_user "test user #{i}" }

      core.users.values.each_combination(2) { |c| assert c[0].uuid != c[1].uuid }
    end

    it "sets the correct displayname" do
      random_string = SecureRandom.base64(100)

      user = core.new_user random_string
      assert user.displayname == random_string
    end
  end
  
  describe "#remove_user" do
    it "updates the users list" do
      user1 = core.new_user "test user 1"
      user2 = core.new_user "test user 2"

      assert core.users.size == 2
      assert core.users.values[0] == user1

      core.remove_user user1

      assert core.users.size == 1
      assert core.users.values[0] == user2
    end

    it "deletes the user from all channels" do
      server1 = core.new_server "test server 1"
      server2 = core.new_server "test server 2"

      chan1 = core.new_channel "test channel 1 (server 1)", server1
      chan2 = core.new_channel "test channel 2 (server 1)", server1
      chan3 = core.new_channel "test channel 3 (server 2)", server2
      chan4 = core.new_channel "test channel 4 (server 2)", server2

      user = core.new_user "test user"

      chan1.users << user
      chan2.users << user
      chan3.users << user
      chan4.users << user

      assert chan1.users.includes? user

      core.remove_user user

      assert !chan1.users.includes? user
      assert !chan2.users.includes? user
      assert !chan3.users.includes? user
      assert !chan4.users.includes? user
    end

    it "deletes the privilidges from all channels" do
      server1 = core.new_server "test server 1"
      server2 = core.new_server "test server 2"

      chan1 = core.new_channel "test channel 1 (server 1)", server1
      chan2 = core.new_channel "test channel 2 (server 1)", server1
      chan3 = core.new_channel "test channel 3 (server 2)", server2
      chan4 = core.new_channel "test channel 4 (server 2)", server2

      user = core.new_user "test user"

      privs1 = Hydra::Core::Credentials.new(user, chan2)
      privs1.privilidged = true
      chan2.privilidges[user] = privs1

      privs2 = Hydra::Core::Credentials.new(user, chan4)
      privs2.privilidged = true
      chan4.privilidges[user] = privs2

      assert chan2.privilidges.has_key? user
      assert chan4.privilidges.has_key? user

      core.remove_user user

      assert !chan2.privilidges.has_key? user
      assert !chan4.privilidges.has_key? user
    end
  end
end
