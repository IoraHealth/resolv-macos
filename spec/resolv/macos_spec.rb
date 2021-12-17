require "tempfile"

RSpec.describe Resolv::Macos do
  it "has a version number" do
    expect(Resolv::Macos::VERSION).not_to be nil
  end

  it "can parse resolver files with ports" do
    Tempfile.create('resolv_macos_resolver_port_') do |tmpfile|
      tmpfile.puts "domain localdomain"
      tmpfile.puts "nameserver 127.0.0.1"
      tmpfile.puts "port 55353"
      tmpfile.close
      config_hash = Resolv::Macos.parse_resolv_conf(tmpfile.path)

      expect(config_hash).to eq({
        nameserver_port:  [['127.0.0.1', 55353]],
        search: ['localdomain'],
        ndots: 1,
      })
    end
  end

  it 'sets up each resolver in the default set' do
    skip unless /darwin/ =~ RUBY_PLATFORM

    Dir.mktmpdir do |resolvers_dir|
      File.open(File.join(resolvers_dir, "corp.internal"), "w") do |file|
        file.puts "nameserver 172.100.0.1"
        file.puts "options ndots:2"
        file.puts "port 15353"
        file.close
      end

      File.open(File.join(resolvers_dir, "localhost"), "w") do |file|
        file.puts "nameserver 127.0.0.1"
        file.puts "port 55353"
        file.close
      end

      default_resolvers = ::Resolv::Macos.default_resolvers(resolvers_dir)
      expect(default_resolvers[0]).to be_a(::Resolv::Hosts)
      expect(default_resolvers[1]).to be_a(::Resolv::DNS)
      expect(default_resolvers[2]).to be_a(::Resolv::DNS)
      expect(default_resolvers[3]).to be_a(::Resolv::DNS)

      corp_resolver = default_resolvers[2]
      localhost_resolver = default_resolvers[3]

      # Eww
      corp_config = corp_resolver.instance_variable_get(:@config).instance_variable_get(:@config_info)
      localhost_config = localhost_resolver.instance_variable_get(:@config).instance_variable_get(:@config_info)

      expect(corp_config).to eql({
        nameserver_port: [['172.100.0.1', 15353]],
        search: ['corp.internal'],
        ndots: 2
      })
      expect(localhost_config).to eql({
        nameserver_port: [['127.0.0.1', 55353]],
        search: ['localhost'],
        ndots: 1
      })
    end
  end
end
