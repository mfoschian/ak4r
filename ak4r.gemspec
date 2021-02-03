Gem::Specification.new do |s|
  s.name        = 'ak4r'
  s.version     = '0.2.2'
  s.summary     = "API Keys for Ruby on Rails"
  s.description = "Middleware for adding api keys validation to API"
  s.authors     = ["Stefano Salvador"]
  s.email       = 'stefano.salvador@gmail.com'
  s.files       = Dir['README.*', 'MIT-LICENSE', 'lib/**/*.rb', 'lib/tasks/*.rake']
  s.homepage    =
    'https://github.com/stefanosalvador/ak4r'
  s.license       = 'MIT'
  s.required_ruby_version = '>= 2.0.0'
  s.add_dependency 'rails', '>= 4.2'
end 
