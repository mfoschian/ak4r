require 'ak4r/api_key'
require 'ak4r/token_generator'

namespace :ak4r do
  desc "List all API Key"
  task :list => :environment do
    Ak4r::ApiKey.all.each do |api_key|
      puts "#{api_key.name}\t#{api_key.prefix}\t#{api_key.scopes.join(";")}"
    end
  end
  desc "Create new API Key"
  task :create, [:name, :scopes] => :environment do    
    secret, hash = Ak4r::TokenGenerator.generate
    api_key = Ak4r::ApiKey.create(
      name: args[:name],
      hash: hash,
      prefix: Ak4r::TokenGenerator.friendly_token(7),
      scopes:  args[:scopes].split(';')
    )
    puts "#{api_key.prefix}.#{secret}"
  end
end
 
