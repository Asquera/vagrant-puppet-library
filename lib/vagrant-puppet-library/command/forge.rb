module Command
  class Forge < Vagrant. plugin(2, :command)

    def self.synopsis 
      "Start the puppet-library server in the foreground to investigate the configuration"
    end

    def execute 
      options = {}
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: vagrant puppet-library <vm-name>" 
        opts.separator ""
      end

      argv = parse_options(opts)
      return if !argv

      vms = argv unless argv.empty?
       
      configs = []
      with_target_vms(vms) { |vm| configs.push vm.config.puppet_library }

      configs.reject! {|c| !c.enabled?}

      if (configs.count > 1)
        boom("You have more than one VM defined. You need to tell me which you want.")
      end

      return if configs.first.nil?
      config = configs.first
      
      
      Rack::Server.start({
        app:  config.server,
        Host: config.host,
        Port: config.port,
      })

      0
    end

    def boom(msg)
      raise Vagrant::Errors::CLIInvalidOptions, :help => usage(msg)
    end

    def usage(msg); <<-EOS.gsub(/^ /, '')
ERROR: #{msg}

#{help}
EOS
    end
 
   def help; <<-EOS.gsub(/^ /, '')
vagrant puppet-library <vm-name>

EOS
    end

  end
end
