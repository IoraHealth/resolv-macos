require "resolv"
require "resolv/macos/version"

class Resolv
  module Macos
    def self.default_resolvers(resolvers_path='/etc/resolver') # :nodoc:
      resolvers = [Hosts.new, DNS.new]

      # macOS supports multiple DNS resolvers via additional configs
      # (e.g. local domain resolvers, VPNs, etc.)
      # ref: `man 5 resolver` on macOS/darwin
      Dir.each_child(resolvers_path) do |filename|
        resolver = ::Resolv::Macos.parse_resolv_conf(
          File.join(resolvers_path, filename)
        )
        resolver[:search] = [filename] unless resolver[:search]
        resolvers << ::Resolv::DNS.new(resolver)
      end

      resolvers
    end

    # Most of this is directly cribbed from Resolv, but with `port` parsing
    # added
    def self.parse_resolv_conf(filename) # :nodoc:
      nameserver = []
        search = nil
        ndots = 1
        port = ::Resolv::DNS::Port
        File.open(filename, 'rb') {|f|
          f.each {|line|
            line.sub!(/[#;].*/, '')
            keyword, *args = line.split(/\s+/)
            next unless keyword
            case keyword
            when 'nameserver'
              nameserver += args
            when 'domain'
              next if args.empty?
              search = [args[0]]
            when 'search'
              next if args.empty?
              search = args
            when 'options'
              args.each {|arg|
                case arg
                when /\Andots:(\d+)\z/
                  ndots = $1.to_i
                end
              }
            when 'port'
              next if args.empty?
              port = args[0].to_i
            end
          }
        }

        return {
          :nameserver_port => nameserver.to_enum(:each_with_index).map { |ns, i| [ns, port] },
          :search => search,
          :ndots => ndots
        }
    end
  end
end

if /darwin/ =~ RUBY_PLATFORM && Dir.exist?('/etc/resolver')
  Resolv::DefaultResolver.replace_resolvers(Resolv::Macos.default_resolvers)
end
