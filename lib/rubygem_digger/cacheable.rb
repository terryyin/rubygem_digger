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

    def self.receive_upload(file, type, content, version)
      File.open(Pathname(base_path).join(file.original_filename), "wb") do |f|
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

      def load_or_yield(context, &block)
        fn = cache_filename(context)
        block.call(*plan_job(context)) unless File.exists? fn
      end

      def load_or_create(context)
        fn = cache_filename(context)
        return load(fn) if File.exists? fn
        start = Time.now
        self.new.tap do |n|
          n.create(context) if n.respond_to? :create
          n.time_elapsed = Time.now - start
          n.flush(fn)
        end
      end

      def load(fn)
        Zlib::GzipReader.open(fn) do |file|
          Marshal.load(file)
        end
      end

      def all
        []
      end

      def cache_filename_from_content(content)
        cache_filename(context_from_content(content))
      end

      def cache_filename(context)
        Pathname(Cacheable.base_path).join("#{self.name}-#{self.instance_name(context)}-#{self.version}.data")
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
      instance_variables.collect do |k|
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
