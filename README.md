# Rikuesuto / Messēji 

Rikuesuto, Japanese for "Request" pronounced "re-KUES-to", is a Ruby Gem for defining a standard
Request and Response interchange between processes for general
processors. A request can be forwarded to a web server, message queue,
IPC or RPC (Remote Procedure Call).

[![Gem Version](https://badge.fury.io/rb/rikuesuto.svg)](http://badge.fury.io/rb/rikuesuto)

## Installation

Add this line to your application's Gemfile:

    gem 'rikuesuto'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rikuesuto

## Usage

A simple request is a 

```ruby
class Charger
  include Rikuesto::Processor

  def new_request(params={}, controls={})
    @response = Rikuesuto.requestor( {
                  class:       Charges,
                  method:      :post, url:"/api/charges",
                  queue_name:  "charges",
                  http_runner: HttpCharger.new,
                  json_runner: MessageQueueCharger.new,
                  params:      params
                }.merge(controls)).run
  end

  def self.process_request(params)
    @request.pagination     #=> {page:1, pagesize:20,...}
    @request.authorization  #=> [[{}]]
    @request.meta           #=> {request_id:"uuid", ...}

    # ... magic happens here ...

    Rikuesuto.respond(:ok, "Charged", payment:self.payment)
  end
end
```

```ruby
class PostResource < Rikeusto::Resource
  def request; end
  def response; end
  def get; end
  def post; end
  def delete; end
  def put; end
  def collection; end
  def resource; end
  def custom_action; end
[[end]]
```

```ruby
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rikuesuto/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request,
 
[![Gem Version](http://img.youtube.com/vi/MppNFgVV25I/0.jpg]( https://www.youtube.com/watch?v=MppNFgVV25I)
