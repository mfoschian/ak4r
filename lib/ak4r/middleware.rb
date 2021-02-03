require 'ak4r'

require 'ak4r/api_key'
require 'ak4r/token_generator'
require 'ak4r/api_exception'

module Ak4r
  class Middleware
    ##
    # ==== Options
    # 
    # * +:secret+ -           Secret used as salt to generate API keys.
    #  
    # * +:header_key+ -       A way to override the header's name used to store the API key.
    #                         The value given here should reflect how Rack interprets the
    #                         header. For example if the client passes "X-API-KEY" Rack
    #                         transforms interprets it as "HTTP_X_API_KEY". The default
    #                         value is "HTTP_X_API_KEY".
    #
    # * +:url_restriction+ -  A way to restrict specific URLs that should pass through
    #                         the rack-api-key middleware. In order to use pass an Array of Regex patterns.
    #                         If left unspecified all requests will pass through the rack-api-key
    #                         middleware.
    #
    # * +:url_exclusion+ -    A way to exclude specific URLs that should not pass through the
    #                         the rack-api-middleware. In order to use, pass an Array of Regex patterns.
    #
    # ==== Example
    #   use Ak4r,
    #       :salt => "API_KEY_SALT"
    #       :header_key => "HTTP_X_API_KEY",
    #       :url_restriction => [/api/],
    #       :url_exclusion => [/api\/status/]
    def initialize(app, config = {})
      @app = app
      Ak4r.config.update config
    end

    def call(env)
      if constraint?(:url_exclusion) && url_matches(:url_exclusion, env)
        @app.call(env)
      elsif constraint?(:url_restriction)
        url_matches(:url_restriction, env) ? process_request(env) : @app.call(env)
      else
        process_request(env)
      end
    end
    
    private

    def process_request(env)      
      api_key_string = env[Ak4r.config.header_key]
      raise Ak4r::ApiException.new(403, "API Key required") if(api_key_string.nil?)

      api_key_prefix, api_key_secret = api_key_string.split('.')
      api_key = Ak4r::ApiKey.find_by(prefix: api_key_prefix)
      raise Ak4r::ApiException.new(403, "API Key invalid") if(api_key.nil?)

      raise Ak4r::ApiException.new(403, "API Key expired") if(api_key.valid_until && api_key.valid_until < Time.now)

      api_key_hash = Ak4r::TokenGenerator.digest(api_key_secret)
      raise Ak4r::ApiException.new(403, "API Key invalid") if(api_key_hash != api_key.hash)
      
      request = Rack::Request.new(env)
      scope = "#{request.request_method}:#{request.path}"
      raise Ak4r::ApiException.new(403, "API Key not allowed for scope #{scope}") unless(api_key.scopes.include?(scope))
      @app.call(env)
    end

    def constraint?(key)
      !(Ak4r.config.public_send(key).nil? || Ak4r.config.public_send(key).empty?)
    end

    def url_matches(key, env)
      path = Rack::Request.new(env).fullpath
      Ak4r.config.public_send(key).select { |url_regex| path.match(url_regex) }.empty? ? false : true
    end
  end
end
