# `resolv-macos`

On macOS/darwin, `libresolv` supports multiple resolvers. This allows users, VPN
clients, etc. to delegate queries for certain domains to other resolvers, in
addition to the "Super Resolver" specified by `/etc/resolv.conf`. An example of
this would be using something like `dnsmasq` or `launchdns` to resolve a
[Special Use Domain (described by RFC 6761)](https://datatracker.ietf.org/doc/html/rfc6761)
for local development like `*.localhost` or `*.test`

This is supported transparently via the `gethostbyname` and `getaddrinfo` C
calls, but when replacing use of those APIs w/ `Resolv`, these resolutions no
longer happen automatically.

This Gem patches the default behavior of the `Resolv` gem to include these
additional resolvers in the default set, if they exist. (Using public APIs,
there's no monkey-patching here.)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resolv-macos'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install resolv-macos

## Usage

No special usage instructions. The Gem will patch `Resolv` to automatically
provide support for multiple resolvers on macOS, _a la_ the default behavior for
`getaddrinfo`. On platforms other than macOS, this gem does nothing.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maxfierke/resolv-macos.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
