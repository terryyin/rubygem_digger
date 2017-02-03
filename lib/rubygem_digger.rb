require "rubygem_digger/version"
require "rubygem_digger/github_digger"
require "rubygem_digger/cacheable"
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
      @gemHistories&.count || @gems.count
    end

    def frequent_than(number)
      @gems.select! {|g, v| v.count >= number}
      self
    end

    def remove_unstable
      @gems.reject! {|g, v| g =~ /(unstable)|(depricated)/i}
    end

    def last_change_before(date)
      @gemHistories.select {|g| g.last_change_at&.send(:<, date)}
    end

    def load_gems
      @gemHistories = @gems.collect do |gem, versions|
        GemHistory.new(@gems_path, gem, versions.collect{|x| x[1].version})
      end.select! do |history|
        history.exist?
      end
    end
  end

  class GemHistory
    def initialize(path, name, versions)
      @gems_path = Pathname.new(path)
      @name = name
      @versions = versions
    end

    def name
      @name
    end

    def exist?
      @versions.all? do |version|
        File.exists? filename(version)
      end
    end

    def monthly_versions
      @versions.collect{|v| spec(v)&.date}.collect{|d| d.year * 100 + d.month rescue 0}.uniq.count
    end

    def last_change_at
      last&.date
    end

    def last_homepage
      last&.homepage
    end

    def last
      @last||=spec(@versions.last)
    end

    def first_change_at
      spec(@versions.first)&.date
    end

    def popular_in_github(more_than)
      repo = GithubDigger.load(last.homepage)
      if repo
        repo.stars_count > more_than
      end
    end

    def still_have_issues_after(time)
      GithubDigger.issues_updated_after(last.homepage, time)&.send(:>=, 2)
    end

    private
    def spec(version)
      load_package(version).spec
    rescue
      print "X"
    end

    def load_package(version)
      print "."
      STDOUT.flush
      Gem::Package.new filename(version)
    end

    def filename(version)
      @gems_path.join("gems/#{@name}-#{version}.gem").to_s
    end

  end
end
