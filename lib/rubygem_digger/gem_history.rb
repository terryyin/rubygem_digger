require 'rubygem_digger/package_wrapper'

module RubygemDigger
  class GemHistory
    def initialize(path, name, versions, major_versions=false)
      @gems_path = Pathname.new(path)
      @name = name
      @versions = versions
      @major_versions = versions if major_versions
    end

    def having_versions?
      @versions.count > 0
    end

    def before(time)
      self.class.new @gems_path, @name, @versions.select {|v| spec(v).date < time}
    end

    def drop_head_months(months)
      self.class.new @gems_path, @name, major_versions[0..-(months+1)], true
    end

    def keep_months(months)
      self.class.new @gems_path, @name, major_versions.last(months), true
    end

    def name
      @name
    end

    def exist?
      @versions.all? do |version|
        File.exists? filename(version)
      end
    end

    def frequent_than?(times)
      @versions.count >= times
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

    def complicated_enough(nloc)
      last_package.nloc&.send(:>, nloc)
    end

    PackageWrapper.all_fields.each do |w|
      define_method("last_#{w}".to_sym) do
        last_package.send(w.to_sym)
      end
    end

    def last
      @last||=spec(major_versions.last)
    end

    def last_package
      @_last_package ||= package(major_versions.last)
    end

    def package(version)
      @_packages ||= {}
      @_packages[version] ||= CachedPackage.load_or_create(gems_path: @gems_path, name: name, version: version)
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
      p last.homepage
      github.issues_updated_after(last.date)&.send(:>=, 20)
    end

    def on_github?
      github.on_github?
    end

    def github
      CachedGithubDigger.load_or_create(url: last.homepage)
    end

    def major_versions
      @major_versions ||= @versions.collect do |v|
        [month_number(spec(v).date), v]
      end.group_by(&:first).sort.collect do |_, vs|
        vs.last.last
      end
    end

    def load_lizard_report_or_yield(&block)
      major_versions.each do |v|
        CachedPackage.load_or_yield(gems_path: @gems_path, name: name, version: v, &block)
      end
    end

    def load_last_lizard_report_or_yield(&block)
      v = major_versions.last
      CachedPackage.load_or_yield(gems_path: @gems_path, name: name, version: v, &block)
    end

    def stats_for_last_version
      { name: @name, version: @versions.last, stat: last_package.stats_for_report }
    end

    def stats_for_all_versions
      major_versions.zip((major_versions.count - 1).downto(0)).collect do |v, age|
        begin
          { name: @name, version: v, age: age, stat: package(v).stats_with_delta(last_package) }
        rescue NoMethodError
          nil
        end
      end.compact
    end

    def collect_all_smells
      last_package.all_smells
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

