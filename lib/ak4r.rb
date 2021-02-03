require 'ak4r/configuration'
require 'ak4r/railtie'

module Ak4r
  def self.configure
    yield config
  end

  def self.config
    @config ||= Configuration.new
  end
end
