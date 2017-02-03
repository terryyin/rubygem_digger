module RubygemDigger
  module Cacheable
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def invalidate

      end

      def all
        []
      end

    end
  end
end
