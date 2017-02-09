module RubygemDigger
  class HistoriesWrapper
    def initialize(histories)
      @histories = histories
    end

    def list
      @histories
    end

    def count
      @histories.count
    end

    def load_dates
      @histories.each{|g| g.all_dates}
    end

    def frequent_than(times)
      self.class.new @histories.select{|g| g.frequent_than?(times)}
    end

    def been_maintained_for_months_before(date, times)
      self.class.new @histories.select{|g| g.months_with_versions{|d| d <= date} >= times}
    end

    def last_change_before(date)
      self.class.new @histories.select {|g| g.last_change_at&.send(:<, date)}
    end

    def complicated_enough
      self.class.new @histories.select {|g| g.complicated_enough}
    end

    def black_list(list)
      self.class.new @histories.reject {|g| list.include? g.name}
    end

    def histories_months_before(months)
      self.class.new @histories[0..-(months+1)]
    end

    def having_issues_after_last_version
      self.class.new @histories.select {|g| g.still_have_issues_after_last_version}
    end

    def stats_for_last_packages(label)
      @histories.collect {|g| g.stats_for_last_version.merge({label: label})}
    end

    def load_lizard_report_or_yield(&block)
      @histories.each {|g| g.load_lizard_report_or_yield(&block)}
    end

    def load_last_lizard_report_or_yield(&block)
      @histories.each {|g| g.load_last_lizard_report_or_yield(&block)}
    end

    PackageWrapper.all_fields.each do |w|
      define_method("average_last_#{w}".to_sym) do
        @histories.collect(&"last_#{w}".to_sym).instance_eval { reduce(:+) / size.to_f}
      end
    end

  end
end
