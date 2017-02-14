require 'rubygem_digger/steps'

module RubygemDigger
  class DigSuccess
    def successful?
      true
    end
  end

  class Digger
    def past_specs
      {
        "1" => {
          version: 1,
          description: "most data",
          min_number_of_gems: 12,
          min_months: 10,
          min_nloc: 2000,
          min_months_good: 20,
          history_months: 20,
          stopped_time_point: Time.utc(2015, 1, 1),
          ignored_months_for_good: 10,

        },

        "2" => {
          version: 2,
          description: "less months",
          min_number_of_gems: 12,
          min_months: 10,
          min_nloc: 2000,
          min_months_good: 20,
          history_months: 12,
          stopped_time_point: Time.utc(2015, 1, 1),
          ignored_months_for_good: 12,
        },

        "3" => {
          version: 3,
          description: "long abondoned",
          min_number_of_gems: 12,
          min_months: 10,
          min_nloc: 2000,
          min_months_good: 24,
          history_months: 10,
          stopped_time_point: Time.utc(2014, 7, 1),
          ignored_months_for_good: 14,
        },

        "4" => {
          version: 4,
          description: "more code",
          min_number_of_gems: 12,
          min_months: 10,
          min_nloc: 5000,
          min_months_good: 20,
          history_months: 20,
          stopped_time_point: Time.utc(2015, 1, 1),
          ignored_months_for_good: 10,
        },

        "5" => {
          version: 5,
          description: "long maintained but stopped",
          min_number_of_gems: 12,
          min_months: 15,
          min_nloc: 2000,
          min_months_good: 20,
          history_months: 20,
          stopped_time_point: Time.utc(2015, 1, 1),
          ignored_months_for_good: 10,
        },

         "7" => {
          version: 7,
          description: "longer maintained for good",
          min_number_of_gems: 12,
          min_months: 12,
          min_nloc: 2000,
          min_months_good: 30,
          history_months: 15,
          stopped_time_point: Time.utc(2015, 1, 1),
          ignored_months_for_good: 15,

        },

          "8" => {
          version: 8,
          description: "balanced",
          min_number_of_gems: 12,
          min_months: 15,
          min_nloc: 3000,
          min_months_good: 30,
          history_months: 10,
          stopped_time_point: Time.utc(2015, 1, 1),
          ignored_months_for_good: 15,
        }
      }
    end
    def spec
      past_specs["1"]
    end

    def tasks
      [
      Steps::GeneralInfo,
      Steps::ActivelyMaintainedPackages,
      Steps::WellMaintainedPackages,
      Steps::MaintanceStoppedPackagesAndTrimTheGood,
      Steps::GetAllLastLizardReport,
      Steps::ComplicatedEnough,
      Steps::StoppedButHavingIssues,
      Steps::SimpleAnalysis,
      Steps::GenerateJsonForLastVersions,
      Steps::GetAllLizardReport,
      Steps::GenerateJsonForAllVersions,
      #files diff
      #get rubygems downlowds count
      # split the rubocop styles, as it's the biggest finding
      # remove global from lizard report, put back the data.
      ]
    end

    def dig(version, &block)
      p version
      context = {
        spec: past_specs[version.to_s],
        time_point: Time.utc(2015, 1, 1),
        job_plan: block,
        black_list: %w{appium_lib rhodes backlog adwords4r mongoid backports riak-client dirty_history gon riddl rspec utopia ohai}
      }
      tasks.each do |t|
        context = t.run context
      end
      context
    end
  end
end
