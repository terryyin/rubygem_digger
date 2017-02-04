module RubygemDigger
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

    def months_with_versions(&date_condition)
      print "."
      STDOUT.flush
      dates = all_dates
      if date_condition
        dates = dates.select(&date_condition)
      end
      dates.collect{|d| d.year * 100 + d.month}.uniq.count
    end

    def all_dates
      @all_dates ||= @versions.collect{|v| spec(v)&.date}.compact
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
      load_spec(version)
    rescue
      print "X"
    end

    def load_spec(version)
      Marshal.load Gem.inflate(Gem.read_binary(filename(version)))
    end

    def filename(version)
      @gems_path.join("quick/Marshal.4.8/#{@name}-#{version}.gemspec.rz").to_s
    end

  end
end

