begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant Puppet-Library plugin must be run within Vagrant."
end


module VagrantPlugins
  module PuppetLibrary 
    class Plugin < Vagrant.plugin("2")
      name "vagrant-puppet-library"
      description <<-DESC
A Vagrant plugin to spin up a puppet library instance.
DESC
#      action_hook "puppet_library" do |hook|
#        # XXX see if we can only hook so long as a command option isn't passed
#        hook.before Vagrant::Action::Builtin::Provision, Action::StartForge
#      end

      command("puppet-library", primary: false) do
         require_relative "command/forge"
         Command::Forge
      end

      action_hook "start_puppet_library" do |hook|
        require_relative "action/boot_puppet_library" 
        hook.before VagrantPlugins::LibrarianPuppet::Action::Install, Action::BootPuppetLibrary
      end

      config "puppet_library" do
        require_relative "config"
        Config
      end
    end
  end
end
