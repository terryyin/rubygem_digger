require 'rubygem_digger/package_wrapper'

module RubygemDigger
  class GemHistory
    def initialize(path, name, versions)
      @gems_path = Pathname.new(path)
      @name = name
      @versions = versions
    end

    def having_versions?
      @versions.count > 0
    end

    def before(time)
      self.class.new @gems_path, @name, @versions.select {|v| spec(v).date < time}
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
      dates.collect{|d| month_number(d)}.uniq.count
    end

    def month_number(d)
      d.year * 100 + d.month
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

    def complicated_enough
      last_package.nloc&.send(:>, 3000)
    end

    PackageWrapper.lizard_fields.each do |w|
      define_method("last_#{w}".to_sym) do
        last_package.send(w.to_sym)
      end
    end

    def last
      @last||=spec(@versions.last)
    end

    def last_package
      CachedPackage.load_or_create(gems_path: @gems_path, name: name, version: @versions.last)
    end

    def first_change_at
      spec(@versions.first)&.date
    end

    def popular_in_github(more_than)
      repo = CachedGithubDigger.load_or_create(url: last.homepage)
      if repo
        repo.stars_count > more_than
      end
    end

    def still_have_issues_after_last_version
      p last.homepage, last.date
      repo = CachedGithubDigger.load_or_create(url: last.homepage)
      repo.issues_updated_after(last.date)&.send(:>=, 2)
    end

    def load_lizard_report_or_yield(&block)
      @versions.collect do |v|
        [month_number(spec(v).date), v]
      end.group_by(&:first).each do |_, vs|
        v = vs.last.last
        p "#{name} #{v}"
        CachedPackage.load_or_yield(gems_path: @gems_path, name: name, version: v, &block)
      end
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

