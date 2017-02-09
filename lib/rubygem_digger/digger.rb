require 'rubygem_digger/steps'

module RubygemDigger
  class DigSuccess
    def successful?
      true
    end
  end

  class Digger
    def past_specs
      [{
        version: 3,
        min_number_of_gems: 12,
        min_months: 10,
        min_nloc: 5000,
        min_months_good: 20,
        stopped_time_point: Time.utc(2015, 1, 1),
        min_months_bad: 10,
        ignored_months_for_good: 10,

      }]
    end
    def spec
      {
        version: 1,
        min_number_of_gems: 12,
        min_months: 10,
        min_nloc: 2000,
        min_months_good: 20,
        stopped_time_point: Time.utc(2015, 1, 1),
        min_months_bad: 10,
        ignored_months_for_good: 10,

      }
    end

    def tasks
      [
      Steps::GeneralInfo,
      Steps::ActivelyMaintainedPackages,
      Steps::WellMaintainedPackages,
      Steps::MaintanceStoppedPackages,
      Steps::GetAllLastLizardReport,
      Steps::ComplicatedEnough,
      Steps::GenerateJsonForLastVersions,
      Steps::SimpleAnalysis,
      Steps::GetAllLizardReport,
      #Steps::StoppedButHavingIssues,
      #get rubygems downlowds count
      ]
    end

    def dig(&block)
      context = {
        spec: spec,
        time_point: Time.utc(2015, 1, 1),
        job_plan: block,
        black_list: %w{rhodes backlog adwords4r mongoid backports riak-client dirty_history gon riddl rspec utopia}
      }
      tasks.each do |t|
        context = t.run context
      end
      DigSuccess.new
    end
  end
end
