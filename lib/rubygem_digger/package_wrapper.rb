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

    def self.lizard_fields
      %w{nloc avg_ccn avg_nloc avg_token fun_count warning_count fun_rate nloc_rate}
    end

    self.lizard_fields.each do |w|
      define_method(w) do
        lizard_data[w.to_sym]
      end
    end

    def lizard_data
      analyze || {}
    end

    private
    def output
      @output ||= Dir.mktmpdir {|dir|
        package.extract_files dir
        o = ''
        Open3.popen3("lizard -t4 -lruby -C4 #{dir}") do |stdout, stderr, status, thread|
          while line=stderr.gets do
            o += line
          end
        end
        o
      }
    end

    def analyze
      if output.scrub =~ %r{nloc Rt\s+\-+\s+(\d+)\s+([\d\.]+)\s+([\d\.]+)\s+([\d\.]+)\s+(\d+)\s+(\d+)\s+([\d\.]+)\s+([\d\.]+)}m
        {
          nloc: $~[1].to_i,
          avg_nloc: $~[2].to_f,
          avg_ccn: $~[3].to_f,
          avg_token: $~[4].to_f,
          fun_count: $~[5].to_i,
          warning_count: $~[6].to_i,
          fun_rate: $~[7].to_f,
          nloc_rate: $~[8].to_f,
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

    def self.gems_path=(path)
      @@gems_path= path
    end

    def self.default_gems_path
      @@gems_path
    end

    def gems_path
      @gems_path || @@gems_path
    end

    def self.plan_job(context)
      [self.name, instance_name(context), version]
    end

    def self.context_from_content(content)
      content=~ /^(.*)\-([\d\.]+)$/
      {
        name: $~[1],
        version: $~[2]
      }
    end

    def self.instance_name(context)
      "#{context[:name]}-#{context[:version]}"
    end

    def create(context)
      @package = PackageWrapper.new(
        context[:gems_path] || gems_path,
        context[:name],
        context[:version])
      @package.lizard_data
    end

    PackageWrapper.lizard_fields.each do |w|
      define_method(w) do
        @package.send(w.to_sym)
      end
    end
  end
end
