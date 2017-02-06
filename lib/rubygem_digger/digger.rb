require 'rubygem_digger/steps'

module RubygemDigger
  class DigSuccess
    def successful?
      true
    end
  end

  class Digger
    def tasks
      [
      Steps::GeneralInfo,
      Steps::ActivelyMaintainedPackages,
      Steps::WellMaintainedPackages,
      Steps::MaintanceStoppedPackages,
      Steps::ComplicatedEnough,
      Steps::SimpleAnalysis,
      #Steps::StoppedButHavingIssues,
      Steps::GetAllLizardReport,
      #get rubygems downlowds count
      ]
    end

    def dig(&block)
      context = {
        time_point: Time.utc(2015, 1, 1),
        job_plan: block
      }
      tasks.each do |t|
        context = t.run context
      end
      DigSuccess.new
    end

    def dig!
      context = {time_point: Time.utc(2015, 1, 1)}
      tasks.each do |t|
        context = t.run context
      end
      DigSuccess.new
    end
  end
end
