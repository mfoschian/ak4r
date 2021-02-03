# frozen_string_literal: true

require 'openssl'

require 'ak4r/api_key'

# Adapted from Devise::TokenGenerator
module Ak4r
  class TokenGenerator
    DIGEST = "SHA256"

    def self.digest(value)
      key = generate_key
      value.present? && OpenSSL::HMAC.hexdigest(DIGEST, key, value.to_s)
    end

    def self.generate
      key = generate_key
      loop do
        raw = self.friendly_token
        enc = OpenSSL::HMAC.hexdigest(DIGEST, key, raw)
        break [raw, enc] unless Ak4r::ApiKey.where(hash: enc).any?
      end
    end
    
    def self.generate_key
      return  Rails.application.key_generator.generate_key(Ak4r.config.salt)
    end

    def self.friendly_token(length = 20)
      # To calculate real characters, we must perform this operation.
      # See SecureRandom.urlsafe_base64
      rlength = (length * 3) / 4
      SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
    end
  end
end 
