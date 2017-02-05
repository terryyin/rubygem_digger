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

    def having_issues_after(time)
      self.class.new @histories.select {|g| g.still_have_issues_after(time)}
    end

  end
end
