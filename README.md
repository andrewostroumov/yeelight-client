# YeelightClient

Official implementation of Yeelight Operation Spec

https://www.yeelight.com/en_US/developer

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yeelight-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yeelight-client

## Usage

This gem split into two parts. The first is to how to discover all Yeelight lights in your local network.
```ruby
results = YeelightClient::Broadcast.new(logger: Logger.new(STDOUT)).discover
results.first.addr
```

You will see something like this if your have many lights:

```
I, [2019-11-02T23:42:56.142927 #3071]  INFO -- : Receive #<UDPSocket:fd 9, AF_INET, 0.0.0.0, 56343>
I, [2019-11-02T23:42:56.143275 #3071]  INFO -- : Receive #<UDPSocket:fd 9, AF_INET, 0.0.0.0, 56343>
I, [2019-11-02T23:42:56.143811 #3071]  INFO -- : Receive #<UDPSocket:fd 9, AF_INET, 0.0.0.0, 56343>
I, [2019-11-02T23:42:56.144785 #3071]  INFO -- : Receive #<UDPSocket:fd 9, AF_INET, 0.0.0.0, 56343>
I, [2019-11-02T23:42:56.144911 #3071]  INFO -- : Receive #<UDPSocket:fd 9, AF_INET, 0.0.0.0, 56343>
I, [2019-11-02T23:42:56.145422 #3071]  INFO -- : Receive #<UDPSocket:fd 9, AF_INET, 0.0.0.0, 56343>
```

Get an addr from results:
```
irb(main):002:0> results.first.addr
=> #<Addrinfo: 192.168.31.64:55443 TCP>
irb(main):003:0> addr.ip_address
=> "192.168.31.16"
irb(main):004:0> addr.ip_port
=> 55443
```


For now you have every Yeelight host and port. We have to go next part of this gem Yeelight Client.

Initialize client with received addr or with host and port

```ruby
client = YeelightClient.new(addrs: addr, logger: Logger.new(STDOUT))
```

```ruby
client = YeelightClient.new(capabilities: { host: "192.168.31.16", port: 55443 }, logger: Logger.new(STDOUT))
```

Client supports only two methods: set_bright and set_rgb

```ruby
client.set_bright(100)
client.set_rgb(0xff0000)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yeelight-client.
