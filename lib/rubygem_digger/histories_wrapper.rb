module RubygemDigger
  class HistoriesWrapper
    def initialize(histories)
      @histories = histories
    end

    def count
      @histories.count
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

    def histories_before(time)
      self.class.new @histories.collect {|g| g.before(time)}.select(&:having_versions?)
    end

    def having_issues_after_last_version
      self.class.new @histories.select {|g| g.still_have_issues_after_last_version}
    end

    def load_lizard_report_or_yield(&block)
      @histories.each {|g| g.load_lizard_report_or_yield(&block)}
    end

    PackageWrapper.lizard_fields.each do |w|
      define_method("average_last_#{w}".to_sym) do
        @histories.collect(&"last_#{w}".to_sym).instance_eval { reduce(:+) / size.to_f}
      end
    end

  end
end
