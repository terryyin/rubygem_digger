#
# RubygemDigger::Cacheable is the trait for any value
# class to become cacheable.
#
# The global setting:
#
#     RubygemDigger::Cacheable.bash_path
#
# decides where to store the cached data.
# The file name will be the class name plus the version number,
# if it's a singleton object. Otherwise these will also be something
# to indenfy the object in the file name.
#
# Interfaces to implement to become 'cacheable':
#
#   create: creating the object (without caching)
#
#

require 'pathname'
require 'zlib'

module RubygemDigger
  module Cacheable
    def self.base_path
      @@base_path
    end

    def self.base_path=(base_path)
      @@base_path = base_path
    end

    def self.receive_upload(file, _type, _content, _version)
      File.open(Pathname(base_path).join(file.original_filename), 'wb') do |f|
        f.write(file.read)
      end
    end

    def self.create_or_load_by_type(type, content, version)
      RubygemDigger.const_get(type).load_or_create_if_match_version(content, version)
    end

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def version=(v)
        @version = v
      end

      def version
        @version
      end

      def invalidate
        File.delete(cache_filename({}))
      rescue Errno::ENOENT
      end

      def load_or_create_if_match_version(content, version)
        return unless version.to_s == @version.to_s
        load_or_create(context_from_content(content))
      end

      def load_or_yield(context)
        fn = cache_filename(context)
        unless File.exist? fn
          unless respond_to?(:upgrade) && upgrade_cache(context)
            yield(*plan_job(context))
          end
        end
      end

      def upgrade_cache(context)
        fn = cache_filename_for_version(context, version - 1)
        return unless File.exist? fn
        o = load(fn)
        o = upgrade(context, o)
        o.flush(cache_filename(context))
      end

      def load_or_create(context)
        fn = cache_filename(context)
        return load(fn) if File.exist? fn
        just_create(context)
      end

      def load(fn)
        Zlib::GzipReader.open(fn) do |file|
          Marshal.load(file)
        end
      end

      def just_create(context)
        fn = cache_filename(context)
        start = Time.now
        new.tap do |n|
          n.create(context) if n.respond_to? :create
          n.time_elapsed = Time.now - start
          n.spec_version = context[:spec][:version] if n.respond_to? :spec_version=
          n.flush(fn)
        end
      end

      def all
        []
      end

      def cache_filename_from_content(content)
        cache_filename(context_from_content(content))
      end

      def cache_filename(context)
        cache_filename_for_version(context, version)
      end

      def cache_filename_for_version(context, version)
        Pathname(Cacheable.base_path).join("#{name}-#{instance_name(context)}-#{version}.data")
      end

      def json_filename(context, version)
        Pathname(Cacheable.base_path).join('..', 'notebook', "#{name.tr(':', '-')}-#{instance_name(context)}-#{version}.data.json")
      end

      def instance_name(context)
        context[:instance_name]
      end
    end

    def time_elapsed=(te)
      @time_elapsed = te
    end

    def time_elapsed
      @time_elapsed
    end

    def flush(fn)
      Zlib::GzipWriter.open(fn) do |file|
        Marshal.dump(self, file)
      end
      self
    end

    def marshal_dump
      instance_variables.reject do |k|
        k.to_s.start_with? '@_'
      end.collect do |k|
        [k, instance_variable_get(k)]
      end
    end

    def marshal_load(vars)
      vars.each do |k, v|
        instance_variable_set(k, v)
      end
    end
  end
end
