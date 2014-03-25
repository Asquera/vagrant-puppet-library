require "puppet_library"

module VagrantPlugins
  module PuppetLibrary 
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :port
      attr_accessor :host
      attr_accessor :enabled
      attr_accessor :module_dir
      attr_accessor :sources

      def initialize
        @port = UNSET_VALUE
        @host = UNSET_VALUE
        @enabled = UNSET_VALUE 
        @sources = []
      end

      def finalize!
        @port = 8080 if @port == UNSET_VALUE
        @host = '0.0.0.0' if @host == UNSET_VALUE
      end

      def add_proxy(url, cache = false, cache_dir = nil)
        #cache_dir ||= # provide a default here 
        if (cache)
           @sources.push({type: :cache, url: url, path: cache_dir})
        else
           @sources.push({type: :proxy, url: url}) 
        end
      end

      def add_module_dir(path)
        @sources.push({type: :directory, path: path})
      end

      def add_source_dir(path)
        @sources.push({type: :source, path: path})
      end

      def enabled?
        @enabled
      end

      def enable!
        @enabled = true
      end

      def disable!
        @enabled = false
      end

      # Merge another configuration object into this one. This assumes that
      # the other object is the same class as this one. This should not
      # mutate this object, but instead should return a new, merged object.
      #
      # The default implementation will simply iterate over the instance
      # variables and merge them together, with this object overriding
      # any conflicting instance variables of the older object. Instance
      # variables starting with "__" (double underscores) will be ignored.
      # This lets you set some sort of instance-specific state on your
      # configuration keys without them being merged together later.
      #
      # @param [Object] other The other configuration object to merge from,
      # this must be the same type of object as this one.
      # @return [Object] The merged object. 
      def merge(other)
        result = super

        result.sources = other.sources + self.sources
        result
      end


      # retrieve the defined rack server from the config
      def server
        ::PuppetLibrary::Server.configure do
          sources.each do |src|
            type = src.delete(:type)
            forge type do
              src.each {|k, v| self.send(k, v) }
            end
          end
        end 
      end
    end
  end
end
