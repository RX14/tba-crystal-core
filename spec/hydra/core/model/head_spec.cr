require "../../../spec_helper"

Spec2.describe Hydra::Core::Head do
  after { core_cleanup }

  describe "#new_access_token" do
    it "generates a new access token" do
      server = Hydra::Core.new_server "test server"
      head = Hydra::Core.new_head server

      old_token = head.access_token
      head.new_access_token

      assert head.access_token != old_token
    end
  end
end
