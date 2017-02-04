require 'rubygem_digger/steps'

module RubygemDigger
  class DigSuccess
    def successful?
      true
    end
  end

  class Digger
    def dig!
      time = Time.utc(2015, 1, 1)
      context = Steps::ActivelyMaintainedPackages.run({})
      context = Steps::WellMaintainedPackages.run context
      context = Steps::MaintanceStoppedPackages.run context
      #specs = RubygemDigger::GemsSpecs.new "/Users/terry/git/gems/"
      #specs.frequent_than(20)
      #p specs.last_change_before(time).count
      DigSuccess.new
    end
  end
end
