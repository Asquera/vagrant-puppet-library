require 'net/http'
require 'vagrant-puppet-library/error'

module VagrantPlugins
  module PuppetLibrary
    module Action
      class BootPuppetLibrary

        def initialize(app, env)
          @app = app
          @env = env
        end

        def call(env)
          config = env[:machine].config.puppet_library
          return unless config.enabled?

          env[:ui].info "Booting Puppet-Library, please stand by..."

          t = Thread.new {          
            Rack::Server.start({
              app:  config.server,
              Host: config.host,
              Port: config.port,
            })
          }

          host = config.host
          host = '127.0.0.1' if config.host == '0.0.0.0' # 0.0.0.0 is bind to all interfaces
          
          booted = false
          tries = 0
          while !booted
            begin
              Net::HTTP.start('127.0.0.1', config.port) {|http|
                response = http.head('/')
              }
              booted = true
            rescue Errno::ECONNREFUSED
              sleep 1
            end
            tries += 1
            raise ::VagrantPlugins::PuppetLibrary::Errors::BootFailure.new if tries > 30
          end

          env[:ui].info "Puppet Library booted and listening on #{config.host}:#{config.port}."

        end
      end
    end
  end
end
