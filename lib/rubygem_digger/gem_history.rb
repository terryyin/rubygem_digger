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

