#require "gem_history"
require 'rubygems/package'

module RubygemDigger
  class GemsSpecs
    def initialize(path)
      @gems_path = Pathname.new(path)
      fs=Dir.glob(@gems_path.join('specs.*.gz'))
      @all= Marshal.load(Gem.gunzip(File.read(fs.first)))
      @gems = @all.group_by(&:first)
    end

    def count
      gemHistories&.count || @gems.count
    end

    def frequent_than(number)
      @gems.select! {|g, v| v.count >= number}
      self
    end

    def remove_unstable
      @gems.reject! {|g, v| g =~ /(unstable)|(depricated)/i}
    end

    def last_change_before(date)
      gemHistories.select {|g| g.last_change_at&.send(:<, date)}
    end

    def gemHistories
      @gemHistories ||= @gems.collect do |gem, versions|
        GemHistory.new(@gems_path, gem, versions.collect{|x| x[1].version})
      end.select! do |history|
        history.exist?
      end
    end
  end
end
