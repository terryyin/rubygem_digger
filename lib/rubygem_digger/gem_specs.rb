#
# RubygemDigger::GemSpec is the collection of all gems info
#

require 'rubygems/package'
require 'rubygem_digger/histories_wrapper'

class Array
  def second
    length <= 1 ? nil : self[1]
  end
end

module RubygemDigger
  class GemsSpecs
    def initialize(path)
      @gems_path = Pathname.new(path)
      fs = Dir.glob(@gems_path.join('specs.*.gz'))
      @all = Marshal.load(Gem.gunzip(File.read(fs.first)))
      @gems = @all.group_by(&:first)
    end

    def gems_count
      @gems.count
    end

    def versions_count
      @gems.collect(&:second).flatten.count
    end

    def frequent_than(number)
      @gems.select! { |_g, v| v.count >= number }
      self
    end

    def remove_unstable
      @gems.reject! { |g, _v| g =~ /(unstable)|(depricated)/i }
    end

    def versions_of(name)
      @gems[name].collect { |x| x[1].version }
    end

    def histories
      HistoriesWrapper.new(
        @gems.collect do |gem, versions|
          GemHistory.new(@gems_path, gem, versions.collect { |x| x[1].version })
        end.select!(&:exist?)
      )
    end
  end
end
