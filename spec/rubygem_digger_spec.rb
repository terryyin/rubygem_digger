require "spec_helper"
require 'pathname'

describe RubygemDigger do
  let(:data_path) {Pathname.new(__FILE__).join('../data/')}
  it "has a version number" do
    expect(RubygemDigger::VERSION).not_to be nil
  end

  describe RubygemDigger::GemsSpecs do
    subject {RubygemDigger::GemsSpecs.new data_path}
    it {expect(subject.frequent_than(4).count).to eq 0}
    it {expect(subject.frequent_than(3).count).to eq 1}
  end

  describe 'system' do
    subject {RubygemDigger::GemsSpecs.new "/Users/terry/git/gems/"}
    xit {expect(subject.frequent_than(20).count).to eq 17802}
    xit {
      time = Time.utc(2015, 1, 1)
      subject.frequent_than(50).remove_unstable
      expect(subject.count).to be > 0
      subject.load_gems
      #expect(subject.last_change_before(Time.utc(2015, 1, 13)).count).to eq 3
      subject.last_change_before(time).select do |g|
        if g.months_with_versions > 12
          if g.still_have_issues_after(g.last_change_at + 100)
            p "#{g.name} #{g.first_change_at} #{g.last_change_at} #{g.last_homepage}"
          end
        end
      end

    }

  end
end
