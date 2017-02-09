module RubygemDigger
  module Steps
    module Step
      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods
        def run(context)
          p "===================="
          p "Step: #{self.name}"
          o = load_or_create(context)
          unless o.spec_version_match?(context[:spec][:version])
            o=just_create(context)
          end
          o.report if o.respond_to? :report
          p "Time elapsed: #{o.time_elapsed}"
          o.update_context(context)
        end
      end

      def update_context(context)
        context
      end

      def spec_version_match?(v)
        @spec_version.to_i == v.to_i
      end

      def spec_version=(v)
        @spec_version = v
      end
    end

    class GeneralInfo
      include Cacheable
      include Step
      self.version = 4

      def spec_version_match?(v)
        true
      end

      def create(context)
        @specs = RubygemDigger::GemsSpecs.new "/Users/terry/git/gems/"
        @specs = @specs.frequent_than(12)
        @frequent_than_12 = @specs.gems_count
        # to cache the specs
        @histories = @specs.histories
        @histories.load_dates
      end

      def report
        p "total gems (not including rc): #{@specs.gems_count}"
        p "total versions: #{@specs.versions_count}"
        p "packages has more than 12 versions: #{@frequent_than_12}"
      end

      def update_context(context)
        context.merge({
          specs: @specs,
          histories: @histories
        })
      end
    end

    class ActivelyMaintainedPackages
      include Cacheable
      include Step
      self.version = 9

      def create(context)
        @active_packages = context[:histories].frequent_than(12).been_maintained_for_months_before(Time.now, 10)
        @active_packages = @active_packages.black_list(context[:black_list])
      end

      def report
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
      self.version = 7

      def create(context)
        @well_maintained = context[:active_packages].been_maintained_for_months_before(Time.now, 20)
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
      self.version = 8

      def create(context)
        @maintain_stopped = context[:active_packages].last_change_before(context[:time_point])
        @well_maintained_past = context[:well_maintained].histories_months_before(10)
      end

      def update_context(context)
        context.merge({
          maintain_stopped: @maintain_stopped,
          well_maintained_past: @well_maintained_past
        })
      end

      def report
        p "Stopped packaged for 2+ year: #{@maintain_stopped.count}"
      end
    end

    class ComplicatedEnough
      include Cacheable
      include Step
      self.version = 16

      def create(context)
        @maintain_stopped = context[:maintain_stopped].complicated_enough
        @well_maintained_past = context[:well_maintained_past].complicated_enough
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
        @maintain_stopped.list.first(20).each do |h|
          p h.name
        end
      end
    end

    class SimpleAnalysis
      include Cacheable
      include Step
      self.version = 6

      def create(context)
        @stopped_average_ccn = context[:maintain_stopped].average_last_avg_ccn
        @maintained_average_ccn = context[:well_maintained_past].average_last_avg_ccn
        @stopped_average_nloc = context[:maintain_stopped].average_last_avg_nloc
        @maintained_average_nloc = context[:well_maintained_past].average_last_avg_nloc
      end

      def report
        p "average ccn stopped: #{@stopped_average_ccn}"
        p "average ccn well maintained: #{@maintained_average_ccn}"
        p "average nloc/fun stopped: #{@stopped_average_nloc}"
        p "average nloc/fun well maintained: #{@maintained_average_nloc}"
      end
    end

    class StoppedButHavingIssues
      include Cacheable
      include Step
      self.version = 9

      def create(context)
        @maintain_stopped_with_issues = context[:maintain_stopped].having_issues_after_last_version
      end

      def report
        p "stopped and complicated enough and still having issues: #{@maintain_stopped_with_issues.count}"
        p "                                average ccn/fun: #{@maintain_stopped_with_issues.average_last_avg_ccn}"
        p "                                average nloc/fun: #{@maintain_stopped_with_issues.average_last_avg_nloc}"
      end

      def update_context(context)
        context.merge({
          maintain_stopped_with_issues: @maintain_stopped_with_issues,
        })
      end

    end

    class GetAllLizardReport
      include Cacheable
      include Step
      self.version = 12

      def create(context)
        status = true
        count = 0
        context[:maintain_stopped].load_lizard_report_or_yield do |type, content, version|
          status = false
          count+=1
          context[:job_plan].call(type, content, version)
        end
        context[:well_maintained_past].load_lizard_report_or_yield do |type, content, version|
          count+=1
          status = false
          context[:job_plan].call(type, content, version)
        end
        p "          ...#{count} packages need to be loaded..."
        raise ::RubygemDigger::Error::StopAndWork unless status
      end
    end

    class GetAllLastLizardReport
      include Cacheable
      include Step
      self.version = 5

      def create(context)
        status = true

        count = 0
        context[:maintain_stopped].load_last_lizard_report_or_yield do |type, content, version|
          status = false
          count+=1
          context[:job_plan].call(type, content, version)
        end
        context[:well_maintained_past].load_last_lizard_report_or_yield do |type, content, version|
          status = false
          count+=1
          context[:job_plan].call(type, content, version)
        end
        p "          ...#{count} packages need to be loaded..."
        raise ::RubygemDigger::Error::StopAndWork unless status
      end
    end

    class GenerateJsonForLastVersions
      include Cacheable
      include Step
      self.version = 18

      def create(context)
        p "writing to: #{self.class.json_filename(context, context[:spec][:version])}"
        open(self.class.json_filename(context, context[:spec][:version]), "w") do |file|
          file.write({
            spec: context[:spec],
           data: [
            context[:maintain_stopped].stats_for_last_packages("good"),
            context[:well_maintained_past].stats_for_last_packages("bad")
          ].flatten}.to_json)
        end
      end
    end

  end

end
