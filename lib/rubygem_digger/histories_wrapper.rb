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

  end
end
