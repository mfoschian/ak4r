module Ak4r
  class Configuration
    SETTINGS = [:salt, :header_key, :url_restriction, :url_exclusion]

    SETTINGS.each do |setting|
      attr_accessor setting

      define_method "#{setting}?" do
        ![nil, false, []].include? send(setting)
      end
    end

    def initialize
      @salt = "API_KEY_SALT"
      @header_key = "HTTP_X_API_KEY"
      @url_restriction = [/api/]
      @url_exclusion = [/api\/status/]
    end

    def update(settings_hash)
      settings_hash.each do |setting, value|
        unless SETTINGS.include? setting.to_sym
          raise ArgumentError, "invalid setting: #{setting}"
        end

        public_send "#{setting}=", value
      end
    end
  end
end
 
