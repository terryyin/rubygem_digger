module RubygemDigger
  class DigSuccess
    def successful?
      true
    end
  end

  class Digger
    def dig!
      time = Time.utc(2015, 1, 1)
      specs = RubygemDigger::GemsSpecs.new "/Users/terry/git/gems/"
      specs.frequent_than(20)
      specs.load_gems
      p specs.last_change_before(time).count
      DigSuccess.new
    end
  end
end
