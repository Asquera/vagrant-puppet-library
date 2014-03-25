module VagrantPlugins
  module PuppetLibrary
    module Errors
      class BootFailure < ::Vagrant::Errors::VagrantError
        error_key(:puppet_library_boot_failed)
      end
    end
  end
end
