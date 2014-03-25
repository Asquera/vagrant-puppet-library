# Add our custom translations to the load path
I18n.load_path << File.expand_path("../../locales/en.yml", __FILE__)
I18n.reload!

require "vagrant-puppet-library/version"
require "vagrant-puppet-library/plugin"
