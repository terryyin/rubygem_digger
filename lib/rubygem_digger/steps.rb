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
          o.report(context) if o.respond_to? :report
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

      def report(context)
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
        @active_packages = context[:histories]
          .frequent_than(context[:spec][:min_number_of_gems])
          .been_maintained_for_months_before(Time.now, context[:spec][:min_months])
        @active_packages = @active_packages.black_list(context[:black_list])
      end

      def report(context)
        p "packages having at least #{context[:spec][:min_months]} months with versions: #{@active_packages.count}"
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
        @well_maintained = context[:active_packages].been_maintained_for_months_before(Time.now, context[:spec][:min_months_good])
      end

      def update_context(context)
        context.merge({
          well_maintained: @well_maintained
        })
      end

      def report(context)
        p "Well maintained packaged (#{context[:spec][:min_months_good]}+ months): #{@well_maintained.count}"
      end
    end

    class MaintanceStoppedPackages
      include Cacheable
      include Step
      self.version = 8

      def create(context)
        @maintain_stopped = context[:active_packages].last_change_before(context[:spec][:stopped_time_point])
        @well_maintained_past = context[:well_maintained].histories_months_before(context[:spec][:ignored_months_for_good])
      end

      def update_context(context)
        context.merge({
          maintain_stopped: @maintain_stopped,
          well_maintained_past: @well_maintained_past
        })
      end

      def report(context)
        p "Stopped packaged before #{context[:spec][:stopped_time_point]}: #{@maintain_stopped.count}"
      end
    end

    class ComplicatedEnough
      include Cacheable
      include Step
      self.version = 16

      def create(context)
        @maintain_stopped = context[:maintain_stopped].complicated_enough(context[:spec][:min_nloc])
        @well_maintained_past = context[:well_maintained_past].complicated_enough(context[:spec][:min_nloc])
      end

      def update_context(context)
        context.merge({
          maintain_stopped: @maintain_stopped,
          well_maintained_past: @well_maintained_past
        })
      end

      def report(context)
        p "complicated enoug means NLOC > #{context[:spec][:min_nloc]}"
        p "stopped and complicated enough: #{@maintain_stopped.count}"
        p "well maintained and complicated enough: #{@well_maintained_past.count}"
      end
    end

    class SimpleAnalysis
      include Cacheable
      include Step
      self.version = 12

      def create(context)
        @simple_analysis = {good: {avg: {}, stddev: {}}, bad: {avg: {}, stddev: {}}}
        PackageWrapper.all_fields.each do |w|
          p "counting #{w}...."
          @simple_analysis[:good][:avg][w] =
            context[:well_maintained_past].send("average_last_#{w}".to_sym)
          @simple_analysis[:good][:stddev][w] =
            context[:well_maintained_past].send("stddev_last_#{w}".to_sym)
          @simple_analysis[:bad][:avg][w] =
            context[:maintain_stopped].send("average_last_#{w}".to_sym)
          @simple_analysis[:bad][:stddev][w] =
            context[:maintain_stopped].send("stddev_last_#{w}".to_sym)
        end
      end

      def report(context)
        PackageWrapper.all_fields.each do |w|
          p w
          p "   good: #{@simple_analysis[:good][:avg][w]} #{@simple_analysis[:good][:stddev][w]} #{@simple_analysis[:good][:stddev][w]*100/@simple_analysis[:good][:avg][w]} "
          p "   bad:  #{@simple_analysis[:bad][:avg][w]} #{@simple_analysis[:bad][:stddev][w]} #{@simple_analysis[:bad][:stddev][w]*100/@simple_analysis[:bad][:avg][w]}"
        end
      end
    end

    class StoppedButHavingIssues
      include Cacheable
      include Step
      self.version = 9

      def create(context)
        @maintain_stopped_with_issues = context[:maintain_stopped].having_issues_after_last_version
      end

      def report(context)
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
      self.version = 13

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
      self.version = 6

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
