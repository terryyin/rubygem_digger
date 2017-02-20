#
# RubygemDigger::HistoriesWrapper encapsulate the iterative
# operations on a collection of gems with many versions (history).
#

module Enumerable
    def sum
      self.inject(0){|accum, i| accum + i }
    end

    def mean
      self.sum/self.length.to_f
    end

    def sample_variance
      m = self.mean
      sum = self.inject(0){|accum, i| accum + (i-m)**2 }
      sum/(self.length - 1).to_f
    end

    def standard_deviation
      return Math.sqrt(self.sample_variance)
    end

end

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

    def get(name)
      @histories.select{|h| h.name == name}.first
    end

    def count_versions
      @histories.collect{|h| h.major_versions.count}.sum
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

    def complicated_enough(nloc)
      self.class.new @histories.select {|g| g.complicated_enough(nloc)}
    end

    def black_list(list)
      self.class.new @histories.reject {|g| list.include? g.name}
    end

    def drop_head_months(months)
      self.class.new @histories.collect{|h| h.drop_head_months(months)}
    end

    def keep_months(months)
      self.class.new @histories.collect{|h| h.keep_months(months)}
    end

    def having_issues_after_last_version
      self.class.new @histories.select {|g| g.still_have_issues_after_last_version}
    end

    def on_github
      self.class.new @histories.select {|g| g.on_github?}
    end

    def stats_for_last_packages(label)
      @histories.collect {|g| g.stats_for_last_version.merge({label: label})}
    end

    def stats_for_all_packages(label)
      @histories.collect {|g| g.stats_for_all_versions}.flatten.collect{|x| x.merge({label: label})}
    end

    def load_lizard_report_or_yield(&block)
      @histories.each {|g| g.load_lizard_report_or_yield(&block)}
    end

    def load_last_lizard_report_or_yield(&block)
      @histories.collect {|g| g.load_last_lizard_report_or_yield(&block)}
    end

    def collect_all_smells
      @histories.collect {|g| g.collect_all_smells}.flatten.uniq
    end

    PackageWrapper.all_fields.each do |w|
      define_method("average_last_#{w}".to_sym) do
        @histories.collect{|x| x.send("last_#{w}")}.mean
      end
      define_method("stddev_last_#{w}".to_sym) do
        @histories.collect{|x| x.send("last_#{w}")}.standard_deviation
      end
    end

  end
end
