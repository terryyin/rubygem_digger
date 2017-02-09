require "rubygem_digger/cacheable"
require "rubygem_digger/package_wrapper"
require 'tmpdir'
require 'open3'

module RubygemDigger
  class ReekWrapper
    def initialize(base_path, name, version)
      @gems_path = base_path
      @name = name
      @version = version
    end

    def output
      @output ||= Dir.mktmpdir {|dir|
        package.extract_files dir
          `reek -fjson #{dir}`
      }
    end

    def package
      Gem::Package.new(filename(@version))
    end

    def filename(version)
      @gems_path.join("gems/#{@name}-#{version}.gem").to_s
    end
  end

  class CachedReek
    include Cacheable
    self.version = 0

    def gems_path
      @gems_path || CachedPackage.default_gems_path
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
      @package = ReekWrapper.new(
        context[:gems_path] || gems_path,
        context[:name],
        context[:version])
      @package.output
    end

    def output
      @package.output
    end
  end
end

