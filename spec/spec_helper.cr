require "spec2"
require "power_assert"
require "../src/hydra/core"

def core_cleanup
  Hydra::Core.servers.clear
  Hydra::Core.heads.clear
  Hydra::Core.channels.clear
  Hydra::Core.users.clear
end

Spec2.random_order
Spec2.doc
