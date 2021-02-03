module Ak4r
  class Railtie < Rails::Railtie
    config.ak4r = ActiveSupport::OrderedOptions.new

    initializer 'ak4r.initialize' do |app|
      require 'ak4r/middleware'
      app.middleware.use Ak4r::Middleware, config.ak4r
    end

    rake_tasks do
      load File.expand_path('../../tasks/ak4r.rake', __FILE__)
    end
  end
end
 
