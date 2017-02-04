module RubygemDigger
  module Steps
    module Step
      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods
        def run(context)
          o = load_or_create(context)
          o.report
          o.update_context(context)
        end
      end

      def update_context(context)
        context
      end
    end

    class ActivelyMaintainedPackages
      include Cacheable
      include Step
      self.version = 3

      def create(context)
        specs = RubygemDigger::GemsSpecs.new "/Users/terry/git/gems/"
        @gems_count = specs.gems_count
        specs.frequent_than(20)
        @frequent_than_20 = specs.gems_count
        @active_packages = specs.histories.been_maintained_for_months_before(Time.now, 24)
      end

      def report
        p "total gems (not including rc): #{@gems_count}"
        p "packages has more than 20 versions: #{@frequent_than_20}"
        p "packages having at least 12 months with versions: #{@active_packages.count}"
        p "Time elapsed: #{@time_elapsed}"
      end

      def update_context(context)
        {
          active_packages: @active_packages
        }
      end
    end

    class WellMaintainedPackages
      include Cacheable
      include Step
      self.version = 2

      def create(context)
        @well_maintained = context[:active_packages].been_maintained_for_months_before(Time.now, 48)
      end

      def report
        p "Well maintained packaged (24+ months): #{@well_maintained.count}"
        p "Time elapsed: #{@time_elapsed}"
      end
    end

    class MaintanceStoppedPackages
      include Cacheable
      include Step
      self.version = 1

      def create(context)
        time = Time.utc(2015, 1, 1)
        @maintain_stopped = context[:active_packages].last_change_before(time)
      end

      def report
        p "Stopped packaged for 2+ year: #{@maintain_stopped.count}"
        p "Time elapsed: #{@time_elapsed}"
      end
    end
  end
end
