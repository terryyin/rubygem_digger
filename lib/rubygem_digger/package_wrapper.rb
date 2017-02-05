require "rubygem_digger/cacheable"
require 'tmpdir'
require 'open3'

module RubygemDigger
  class PackageWrapper
    def initialize(base_path, name, version)
      @gems_path = base_path
      @name = name
      @version = version
    end

    def nloc
      lizard_data[:nloc]
    end

    def lizard_data
      analyze || {}
    end

    private
    def output
      @output ||= Dir.mktmpdir {|dir|
        package.extract_files dir
        o = ''
        Open3.popen3("lizard -t10 -lruby #{dir}") do |stdout, stderr, status, thread|
          while line=stderr.gets do
            o += line
          end
        end
        print o
        o
      }
    end

    def analyze
      if output.scrub =~ %r{nloc Rt\s+\-+\s+(\d+)}m
        {
          nloc: $~[1].to_i
        }
      end
    end

    def package
      Gem::Package.new(filename(@version))
    end

    def filename(version)
      @gems_path.join("gems/#{@name}-#{version}.gem").to_s
    end
  end

  class CachedPackage
    include Cacheable
    self.version = 2

    def self.instance_name(context)
      "#{context[:name]}-#{context[:version]}"

    end

    def create(context)
      @package = PackageWrapper.new(
        context[:gems_path],
        context[:name],
        context[:version])
      @package.lizard_data
    end

    def nloc
      @package.nloc
    end
  end
end
