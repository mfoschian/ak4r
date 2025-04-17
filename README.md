# AK4R = API Keys for Rails

AK4R is a Rack middleware which adds to Ruby on Rails the ability to protect APi calls whit an API key passed in the request headers.

The implementation is very similar to the description here: https://www.freecodecamp.org/news/best-practices-for-building-api-keys-97c26eabfea9/ ,
using some pieces of the rack-api-key gem.

API keys are stored in an Active Record model and validated at every request.

API keys are scoped, so you have the ability to fine tune permissions.

API keys can optionally expire.

## Installation

Add this line to your Rails application's Gemfile:

    gem 'ak4r'

And then execute:

    $ bundle

Finally you should generate the db migration:

```ruby
rails generate ak4r_migration
rake db:migrate
```

## Usage

Gem auto loads into the Rails application. The default is to protect all urls starting with "/api".
Since initially no key is present every request throws an exception:

```ruby
Ak4r::ApiException
```
you should rescue this in your application, e.g. you can add this line to `application_controller.rb` :

```ruby
rescue_from Ak4r::ApiException, with: :handle_api_authorization
```
## How to generate API keys

There is a rake task for this:

```ruby
rake ak4r:create["name","scope1;scope2"]
```
Scopes are defined as [HTTP_VERB]:path, e.g. `GET:/api/books.json` .

This task outputs the key to put in X-API-KEY header. Please note that the key itself is not stored so you must immediatelly copy it in a secure place.

## Configuration

You can customize its behaviour in your `config/application.rb` :

```ruby
config.ak4r.[option] = '...'
```

If options depend on your environment, you can define it in the according file: `config/environments/<env>.rb`

### :salt
The salt used to generate keys.

### :header_key
It's important to note that internally Rack actually mutates any given headers
and prefixes them with HTTP and subsequently underscores them. For example if an
API client passed "X-API-KEY" in the header, Rack would interpret that header
as "HTTP_X_API_KEY". "HTTP_X_API_KEY" is the default header. If you want to use
a different header you can specify it with this option.
With the default configuration use "X-API-KEY" as header key in requests.

### :url_restriction
This is an option that can restrict the middleware to specific URLs.
This works well when you have a mixture of API endpoints that require
authentication and some that might not. Or a combination of API endpoints and
publicly facing webpages. Perhaps you've scoped all of your API endpoints to
"/api", and the rest of the URL mappings or routes are supposed to be wide open.

### :url_exclusion
This is an option to allow specific URLs to bypass middleware authentication.
This works well when you require a single or few endpoints to not require
authentication. Perhaps you've scoped all of your API endpoints to "/api" but wish
to leave "/api/status" publicly facing.




 
