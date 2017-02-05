require 'rubygem_digger/steps'

module RubygemDigger
  class DigSuccess
    def successful?
      true
    end
  end

  class Digger
    def dig!
      context = {time_point: Time.utc(2015, 1, 1)}
      context = Steps::GeneralInfo.run context
      context = Steps::ActivelyMaintainedPackages.run context
      context = Steps::WellMaintainedPackages.run context
      context = Steps::MaintanceStoppedPackages.run context
      context = Steps::ComplicatedEnough.run context
      #context = Steps::StoppedButHavingIssues.run context
      DigSuccess.new
    end
  end
end
