module RubygemDigger
  module Steps
    module Step
      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods
        def run(context)
          o = load_or_create(context)
          o.report if o.respond_to? :report
          p "Time elapsed: #{o.time_elapsed}"
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
      end

      def update_context(context)
        context.merge({
          active_packages: @active_packages
        })
      end
    end

    class WellMaintainedPackages
      include Cacheable
      include Step
      self.version = 2

      def create(context)
        @well_maintained = context[:active_packages].been_maintained_for_months_before(Time.now, 48)
      end

      def update_context(context)
        context.merge({
          well_maintained: @well_maintained
        })
      end

      def report
        p "Well maintained packaged (24+ months): #{@well_maintained.count}"
      end
    end

    class MaintanceStoppedPackages
      include Cacheable
      include Step
      self.version = 1

      def create(context)
        @maintain_stopped = context[:active_packages].last_change_before(context[:time_point])
      end

      def update_context(context)
        context.merge({
          maintain_stopped: @maintain_stopped
        })
      end

      def report
        p "Stopped packaged for 2+ year: #{@maintain_stopped.count}"
      end
    end

    class ComplicatedEnough
      include Cacheable
      include Step
      self.version = 9

      def create(context)
        @maintain_stopped = context[:maintain_stopped].complicated_enough
        past = context[:well_maintained].histories_before(context[:time_point])
        @well_maintained_past = past.complicated_enough
      end

      def update_context(context)
        context.merge({
          maintain_stopped: @maintain_stopped,
          well_maintained_past: @well_maintained_past
        })
      end

      def report
        p "stopped and complicated enough: #{@maintain_stopped.count}"
        p "well maintained and complicated enough: #{@well_maintained_past.count}"
      end
    end

  end
end
